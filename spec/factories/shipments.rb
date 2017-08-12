FactoryGirl.define do

  factory :shipment do
    tracking_number random_tracking_number

    # Associations
    order

    factory :created do
      shipment_status "created"

      after :create do |created|
        create_list(:radio, 1, :shipment => created)
      end
    end

    factory :fulfillment do
      shipment_status "fulfillment"

      after :create do |fulfillment|
        create_list(:radio, 3, :shipment => fulfillment)
      end
    end

    factory :boxed do
      shipment_status "boxed"
      ship_date "2017-07-28"

      after :create do |boxed|
        create_list(:radio, 2, :shipment => boxed)
      end
    end

    factory :shipped do
      shipment_status "shipped"
      ship_date "2017-07-28"

      after :create do |shipped|
        create_list(:radio, 2, :shipment => shipped)
      end
    end
  end
end


