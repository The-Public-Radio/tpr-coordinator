require 'tracking_number'

class Shipment < ApplicationRecord
  # def date_object_check
  #   errors.add(:ship_date, "Must be a Date object!") unless ship_date.valid_date?
  # end

  has_many :radio
  belongs_to :order
  # use tracking_number gem for validation
  validates :tracking_number, tracking_number: true, allow_nil: true  #, uniqueness: true
  validates_inclusion_of :shipment_status, in: %w(created label_created label_printed shipped boxed transit delivered failure returned unknown),
    allow_nil: true, allow_blank: true
  validates_inclusion_of :shipment_priority, in: %w(economy priority express), allow_nil: true

  def next_unboxed_radio
    self.radio.order(:created_at).select{ |r| r.boxed == false }[0]
  end
end
