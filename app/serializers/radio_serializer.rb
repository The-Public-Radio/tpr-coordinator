class RadioSerializer < ActiveModel::Serializer
  attributes :id, :frequency, :pcb_version, :serial_number, :assembly_date, :operator, :shipment_id, :boxed, :country_code, :firmware_version
end
