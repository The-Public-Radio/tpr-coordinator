FactoryGirl.define do

  factory :shipment do
    tracking_number random_tracking_number

    # Associations
    order

    factory :created do
      shipment_status "created"

      after :create do |created|
        create_list(:radio_inital_order, 1, :shipment => created)
      end
    end

    factory :label_created do
      shipment_status "label_created"

      after :create do |label_created|
        create_list(:radio_boxed, 1, shipment: label_created)
        create_list(:radio_inital_order, 2, shipment: label_created)
      end
    end

    factory :boxed do
      shipment_status "boxed"
      ship_date "2017-07-28"

      after :create do |boxed|
        create_list(:radio_boxed, 4, :shipment => boxed)
      end
    end

    factory :shipped do
      shipment_status "shipped"
      ship_date "2017-07-28"

      after :create do |shipped|
        create_list(:radio_boxed, 2, :shipment => shipped)
      end
    end
  end
end


