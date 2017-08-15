FactoryGirl.define do
  factory :radio_assembled, class: Radio do
    serial_number random_tpr_serial_number
    operator random_operator_name
    assembly_date Time.new
    pcb_version '1'
    boxed false

    factory :radio_boxed, class: Radio do
      frequency random_frequency
      boxed true

      # Associations
      shipment
    end
  end
end
