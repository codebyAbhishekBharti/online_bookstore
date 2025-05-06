FactoryBot.define do
  factory :book do
    title { "Sample Book" }
    description { "A test book." }
    price { 9.99 }
    stock_quantity { 10 }
    vendor { association :user, role: "vendor" }  # 👈 add this line
  end
end
