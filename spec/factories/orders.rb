FactoryGirl.define do
  factory :order do
    name { random_name }
    street_address_1 "123 West 9th St."
    street_address_2 'Apt 4'
    city 'Brooklyn'
    state 'NY'
    postal_code '11221'
    country 'US'
    phone '123-321-1231'
    order_source 'other'
    email { "#{name.split(' ').join}@gmail.com" }
    invoiced false
    notified false

    trait :with_shipments do
      transient do
        shipment_count { 1 }
      end

      after(:create) do |order, evaluator|
        create_list(:boxed, evaluator.shipment_count, order: order)
      end
    end

    factory :warranty, class: Order do
      order_source "warranty"

      after :create do |order|
        create_list(:shipment, 4, :order => order)
      end
    end

    factory :kickstarter, class: Order do
      order_source "kickstarter"

      after :create do |order|
        create_list(:shipment, 4, :order => order)
      end
    end

    factory :squarespace, class: Order do
      order_source "squarespace"
      reference_number "#{Random.rand(999)},#{Random.rand(9999999)}"

      factory :squarespace_order_notified, class: Order do
        notified true
      end

      after :create do |order|
        create_list(:boxed, 2, :order => order)
        create_list(:label_created, 2, :order => order)
      end
    end

    factory :uncommon_goods, class: Order do
      order_source "uncommon_goods"
      reference_number { random_reference_number }

      factory :invoiced_true, class: Order do
        invoiced true
      end

      after :create do |order|
        create_list(:boxed, 2, :order => order)
      end
    end

    factory :invoiced_boxed_false, class: Order do
      invoiced false
      order_source "uncommon_goods"
      reference_number { random_reference_number }

      after :create do |order|
        create_list(:boxed_false, 2, :order => order)
      end
    end
  end

  factory :international_order, class: Order do
    name random_name
    street_address_1 "123 West 9th St."
    street_address_2 'Apt 4'
    city 'Toronto'
    state 'ON'
    postal_code 'M4K 1G5'
    country 'CA'
    phone '123-321-1231'
    order_source 'other'
    email { "#{name.split(' ').join}@gmail.com" }
  end
end
