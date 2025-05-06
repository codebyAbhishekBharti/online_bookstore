# spec/factories/books.rb
FactoryBot.define do
  factory :book do
    title { "Test Book" }
    price { 9.99 }
    stock_quantity { 10 }
  end
end