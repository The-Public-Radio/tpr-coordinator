class Radio < ApplicationRecord
  validates_presence_of :frequency
  validates_length_of :frequency, maximum: 5, message: 'Frequency is not valid: too long!'
  validates_numericality_of :frequency, on: :create, message: 'Frequency is not valid: only numbers!'
  validates_numericality_of :frequency, greater_than: 87.5, message: 'Frequency is not valid: the station is less than 87.5!'
  validates_numericality_of :frequency, less_than: 108, message: 'Frequency is not valid: the station is greater than 108!'
end
