class Radio < ApplicationRecord
  validates_presence_of :frequency
  belongs_to :shipment
end
