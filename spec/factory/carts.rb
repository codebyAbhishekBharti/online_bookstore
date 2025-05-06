# spec/factories/carts.rb
FactoryBot.define do
  factory :cart do
    user
    book
    quantity { 1 }
  end
end
