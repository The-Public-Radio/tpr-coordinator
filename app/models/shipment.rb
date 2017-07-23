require 'tracking_number'

class Shipment < ApplicationRecord
  # def date_object_check
  #   errors.add(:ship_date, "Must be a Date object!") unless ship_date.valid_date?
  # end

  has_many :radio
  # use tracking_number gem for validation
  validates_presence_of :tracking_number
  validates :tracking_number, tracking_number: true
  validates_inclusion_of :status, in: %w(created fulfillment shipped)
  # validates_presence_of :ship_date, allow_nil: true
end
