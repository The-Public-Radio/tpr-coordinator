FactoryGirl.define do
  factory :order do
    first_name "Spencer"
    last_name "Right"
    address "123 West 9th St., City, State, USA"
  end

  factory :kickstarter, class: Order do
    first_name "Zach"
    last_name "Ham"
    address "546 East West Ave., City, State, USA"
    order_source "kickstarter"
  end

   factory :squarespace, class: Order do
    first_name "Gabe"
    last_name "Eight"
    address "123 West 9th St., City, State, USA"
    order_source "squarespace"
  end
end
