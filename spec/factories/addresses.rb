FactoryBot.define do
  factory :address do
    user
    full_name { "John Doe" }
    phone_number { "1234567890" }
    sequence(:address_line1) { |n| "221B Baker Street Apt #{n}" }
    address_line2 { "Flat B" }
    city { "London" }
    state { "England" }
    zip_code { "NW1 6XE" }
    country { "UK" }
    is_default { false }
    address_type { "home" }
  end
end
