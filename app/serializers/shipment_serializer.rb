class ShipmentSerializer < ActiveModel::Serializer
  attributes :id, :tracking_number, :ship_date, :shipment_status, :order_id, :label_data, :priority
end
