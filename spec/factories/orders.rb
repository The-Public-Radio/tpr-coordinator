FactoryGirl.define do
  factory :order do
    first_name "Spencer"
    last_name "Right"
    address "123 West 9th St., City, State, USA"
    order_source 'other'
    email { "#{first_name}.#{last_name}@gmail.com" }

    factory :order_with_shipments do
      # shipments_count is declared as a transient attribute and available in
      # attributes on the factory, as well as the callback via the evaluator
      transient do
        shipments_count 2
    	end

      # the after(:create) yields two values; the order instance itself and the
      # evaluator, which stores all values from the factory, including transient
      # attributes; `create_list`'s second argument is the number of records
      # to create and we make sure the user is associated properly to the post
      after(:create) do |order, evaluator|
        create_list(:post, evaluator.shipments_count, order: order)
      end
    end
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
