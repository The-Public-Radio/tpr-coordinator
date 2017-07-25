class Radio < ApplicationRecord
  validates_presence_of :frequency
  validates_length_of :frequency, maximum: 5, message: 'Frequency is not valid: too long!'
  validates_numericality_of :frequency, greater_than_or_equal_to: 76, message: 'Frequency is not valid: the station is less than 76 !'
  validates_numericality_of :frequency, less_than_or_equal_to: 108, message: 'Frequency is not valid: the station is greater than 108!'
end
