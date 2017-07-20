class Shipment < ApplicationRecord
  has_many :radio
  validates_presence_of :tracking_number, with: /1Z/
  validates_length_of :tracking_number, is: 15, allow_nil: false
end
