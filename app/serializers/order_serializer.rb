class OrderSerializer < ActiveModel::Serializer
  attributes :id, :name, :order_source, :email, :street_address_1, :street_address_2, :city, :state, :postal_code, :country, :phone
end
