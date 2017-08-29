FactoryGirl.define do
  factory :order do
    first_name "Spencer"
    last_name "Right"
    street_address_1 "123 West 9th St."
    street_address_2 'Apt 4'
    city 'Brooklyn'
    state 'NY'
    postal_code '11221'
    country 'US'
    phone '123-321-1231'
    order_source 'other'
    email { "#{first_name}.#{last_name}@gmail.com" }
    
    factory :kickstarter, class: Order do
      order_source "kickstarter"

      after :create do |order|
        create_list(:shipment, 4, :order => order)
      end
    end

     factory :squarespace, class: Order do
      order_source "squarespace"
      after :create do |order|
        create_list(:shipment, 2, :order => order)
      end
    end
  end
end
