require 'tracking_number'

class Shipment < ApplicationRecord
  # def date_object_check
  #   errors.add(:ship_date, "Must be a Date object!") unless ship_date.valid_date?
  # end

  has_many :radio
  belongs_to :order
  # use tracking_number gem for validation
  validates :tracking_number, tracking_number: true, allow_nil: true  #, uniqueness: true
  validates_inclusion_of :shipment_status, in: %w(created label_created shipped boxed), allow_nil: true, allow_blank: true

  def next_unboxed_radio(id)
		Shipment.find(id).radio.sort_by(&:created_at).select{ |s| s.boxed == false }[0]
  end
end
