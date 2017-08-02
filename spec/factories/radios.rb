FactoryGirl.define do
  factory :radio do
    frequency "90.5"
    shipment_id nil
  end

  factory :radio_1, class: Radio do
	  frequency  '107.3'
  	shipment_id 1
  end

  factory :radio_2, class: Radio do
	  frequency  '87.9'
  	shipment_id 2
  end

  factory :radio_3, class: Radio do
	  frequency  '101.3'
  	shipment_id 3
  end

  factory :radio_4, class: Radio do
	  frequency  '103.1'
  	shipment_id 3
  end

  factory :radio_4, class: Radio do
	  frequency  '103.1'
  	shipment_id 3
  end

end
