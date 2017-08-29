class OrderSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :order_source, :email, :street_address_1, :street_address_2, :city, :state, :postal_code, :country, :phone
end
