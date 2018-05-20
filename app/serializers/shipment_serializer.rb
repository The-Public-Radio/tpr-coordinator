class ShipmentSerializer < ActiveModel::Serializer
  attributes :id, :tracking_number, :ship_date, :shipment_status, :order_id, :priority_processing, :label_url, :return_label_url, :shipment_priority, :shippo_reference_id, :rate_reference_id
end
