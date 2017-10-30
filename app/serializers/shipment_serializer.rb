class ShipmentSerializer < ActiveModel::Serializer
  attributes :id, :tracking_number, :ship_date, :shipment_status, :order_id, :label_data, :priority_processing, :label_url
end
