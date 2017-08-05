FactoryGirl.define do
  factory :order do
    first_name "Spencer"
    last_name "Right"
    address "123 West 9th St., City, State, USA"
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
