FactoryGirl.define do
  factory :shipment do
    tracking_number random_tracking_number

    # Associations
    order

    factory :created do
      shipment_status "created"

      after :create do |created|
        create(:radio_inital_order, :shipment => created, serial_number: random_tpr_serial_number)
      end
    end
      
    factory :label_created do
        shipment_status "label_created"
        label_data "label_data_fixture"
        label_url "https://shippo-delivery-east.s3.amazonaws.com/some_label.pdf"

        after :create do |label_created|
          create(:radio_boxed, shipment: label_created, serial_number: random_tpr_serial_number)
          create(:radio_inital_order, shipment: label_created)
          create(:radio_inital_order, shipment: label_created)
        end

      factory :label_printed do
        shipment_status "label_printed"
      end

      factory :priority do
        priority true

        after :create do |label_created|
          create(:radio_boxed, shipment: label_created, serial_number: random_tpr_serial_number)
        end
      end
    end

    factory :boxed do
      shipment_status "boxed"
      ship_date "2017-07-28"
      label_data "label_data_fixture"

      after :create do |boxed|
        create(:radio_boxed, :shipment => boxed, serial_number: random_tpr_serial_number)
        create(:radio_boxed, :shipment => boxed, serial_number: random_tpr_serial_number)
        create(:radio_boxed, :shipment => boxed, serial_number: random_tpr_serial_number)
      end
    end

    factory :shipped do
      shipment_status "shipped"
      ship_date "2017-07-28"
      label_data "label_data_fixture"

      after :create do |shipped|
        create(:radio_boxed, :shipment => shipped, serial_number: random_tpr_serial_number)
        create(:radio_boxed, :shipment => shipped, serial_number: random_tpr_serial_number)
      end
    end
  end
end