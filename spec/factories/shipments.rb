FactoryGirl.define do
  factory :shipment do
    tracking_number "9374889691090496006138"
    order_id 1
  end

  factory :shipment_created, class: Shipment do
  	tracking_number "9374889691090496006138"
    shipment_status "created"
    order_id 1
  end

  factory :shipment_fulfillment, class: Shipment do
  	tracking_number "9374889691090496006138"
    shipment_status "fulfillment"
    order_id 1
  end

  factory :shipment_shipped, class: Shipment do
  	tracking_number "9374889691090496006138"
    ship_date "2017-07-27"
    shipment_status "shipped"
    order_id 1
  end
end
