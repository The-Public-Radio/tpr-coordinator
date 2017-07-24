class OrderSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :adderss, :order_source
end
