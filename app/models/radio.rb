class Radio < ApplicationRecord
	belongs_to :shipment, optional: true
  validates_numericality_of :frequency, 
  	greater_than_or_equal_to: 76, 
  	less_than_or_equal_to: 108, 
  	message: 'Frequency is not valid!', 
  	allow_nil: true
  validates :frequency, length: { maximum: 5 }
  validates_inclusion_of :boxed, in: [true, false], allow_nil: true
  validates :serial_number, uniqueness: true, allow_nil: true
  validates_inclusion_of :country_code, in: %w{us jp eu}, allow_nil: true
end
