FactoryGirl.define do
  factory :base_radio, class: Radio do 
    serial_number random_tpr_serial_number
    operator random_operator_name
    pcb_version '1'

    factory :radio_assembled, class: Radio do
      assembly_date Time.new
      boxed false

      factory :radio_inital_order, class: Radio do
        frequency random_frequency

        # Associations
        shipment

        factory :radio_boxed, class: Radio do
          boxed true
        end
      end
    end
  end
end
