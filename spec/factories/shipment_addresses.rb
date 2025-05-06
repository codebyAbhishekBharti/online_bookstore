# spec/factories/shipment_addresses.rb
FactoryBot.define do
  factory :shipment_address do
    full_name { "John Doe" }
    phone_number { "1234567890" }
    address_line1 { "123 Main St" }
    address_line2 { "Apt 4B" }
    city { "City" }
    state { "State" }
    zip_code { "12345" }
    country { "Country" }
    address_type { "Shipping" }
    user
  end
end
