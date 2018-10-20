FactoryGirl.define do
  factory :retailer do
    name { "Mega Corp" }
    source { "mega_corp" }
    quickbooks_customer_id { 1 }
    generate_invoice { true }
  end
end
