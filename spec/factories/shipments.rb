FactoryGirl.define do
  factory :shipment do
    tracking_number "9374889691090496006138"
    shipment_status nil

	  factory :created do
	    shipment_status "created"
	  end

	  factory :fulfillment do
	    shipment_status "fulfillment"
	  end

	  factory :shipped do
	    shipment_status "shipped"
	  end

	  # Associations
	  order

	  factory :with_radios do
      # shipments_count is declared as a transient attribute and available in
      # attributes on the factory, as well as the callback via the evaluator
      transient do
        radios_count 3
    	end

      # the after(:create) yields two values; the shipment instance itself and the
      # evaluator, which stores all values from the factory, including transient
      # attributes; `create_list`'s second argument is the number of records
      # to create and we make sure the user is associated properly to the post
      after(:create) do |shipment, evaluator|
        create_list(:radio, evaluator.radios_count, shipment: shipment)
      end
    end
	end
end
