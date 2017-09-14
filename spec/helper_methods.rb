require 'json'
require 'faker'

def random_tracking_number
  number = "937488969109049600#{Random.new.rand(9999999)}"
  chars = number.gsub(/^420\d{5}/, '').chars.to_a

  total = 0
  chars.reverse.each_with_index do |c, i|
    x = c.to_i
    x *= 3 if i.even?

    total += x
  end

  check_digit = total % 10
  check_digit = 10 - check_digit unless (check_digit.zero?)
  # TrackingNumber.new("#{number}#{check_digit}")
  "#{number}#{check_digit}"
end

def random_international_tracking_number
  number = "LZ78#{Random.new.rand(9999999)}US"
  chars = number.gsub(/^420\d{5}/, '').chars.to_a

  total = 0
  chars.reverse.each_with_index do |c, i|
    x = c.to_i
    x *= 3 if i.even?

    total += x
  end

  check_digit = total % 10
  check_digit = 10 - check_digit unless (check_digit.zero?)
  # TrackingNumber.new("#{number}#{check_digit}")
  "#{number}#{check_digit}"
end

def random_tpr_serial_number
  "TPRv2.0_1_#{Random.new.rand(99999)}"
end

def random_name
  Faker::Name.name
end

def random_frequency
  Random.new.rand(78.0..108.0).round(1)
end

def load_fixture(path)
  File.read(path)
end

def load_json_fixture(path)
  JSON.parse(load_fixture(path), symbolize_names: true)
end

