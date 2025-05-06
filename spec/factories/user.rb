FactoryBot.define do
  factory :user do
    name { "Test User" }
    sequence(:email) { |n| "test_user_#{n}@example.com" }
    password { "password123" }
    phone_number { "1234567890" }
    address { "123 Test St" }
    role { "user" }
  end
end
