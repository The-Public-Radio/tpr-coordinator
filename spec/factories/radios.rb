FactoryGirl.define do
  factory :radio do
    frequency '90.5'
    pcb_version '1'
    serial_number 'TPRv2.0_1_12345'
    assembly_date Time.new
    operator 'some_operator_name'

    # Associations
    shipment

    factory :radio_1, class: Radio do
  	  frequency  '90.5'
    end

    factory :radio_2, class: Radio do
  	  frequency  '87.9'
    end

    factory :radio_3, class: Radio do
      frequency  '103.1'
    end

    factory :radio_4, class: Radio do
      frequency  '103.1'
    end

    factory :radio_5, class: Radio do
  	  frequency  '101.3'
  	end
  end
end
