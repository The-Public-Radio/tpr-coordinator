class ShipmentSerializer < ActiveModel::Serializer
  attributes :id, :tracking_number, :ship_date, :status
end
