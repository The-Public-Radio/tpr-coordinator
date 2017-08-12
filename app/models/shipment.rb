require 'tracking_number'

class Shipment < ApplicationRecord
  # def date_object_check
  #   errors.add(:ship_date, "Must be a Date object!") unless ship_date.valid_date?
  # end

  has_many :radio, dependent: :destroy
  belongs_to :order
  # use tracking_number gem for validation
  validates :tracking_number, tracking_number: true, allow_nil: true  #, uniqueness: true
  validates_inclusion_of :shipment_status, in: %w(created fulfillment shipped boxed), allow_nil: true, allow_blank: true
end
