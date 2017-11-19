class ShipmentSerializer < ActiveModel::Serializer
  attributes :id, :tracking_number, :ship_date, :shipment_status, :order_id, :priority_processing, :label_url, :shipment_priority
end
