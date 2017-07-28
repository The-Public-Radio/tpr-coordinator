class OrderSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :address, :order_source, :email
end
