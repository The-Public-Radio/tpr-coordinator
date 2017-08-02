FactoryGirl.define do
  factory :radio do
    frequency "90.5"

    # Associations
    association :shipment
  end

  factory :radio_1, class: Radio do
	  frequency  '107.3'

    # Associations
  	association :shipment, factory: :created
  end

  factory :radio_2, class: Radio do
	  frequency  '87.9'
  	shipment_id 2

    # Associations
  	association :shipment, factory: :fulfillment
  end

  factory :radio_3, class: Radio do
	  frequency  '101.3'
  	shipment_id 3

  	 # Associations
  	association :shipment, factory: :shipped

	  factory :radio_4, class: Radio do
		  frequency  '103.1'
	  end

	  factory :radio_5, class: Radio do
		  frequency  '103.1'
	  end
	end

end
