require 'tracking_number'

class Shipment < ApplicationRecord
  has_many :radio
  # use tracking_number gem for validation
  validates_presence_of :tracking_number, :tracking_number => true
end
