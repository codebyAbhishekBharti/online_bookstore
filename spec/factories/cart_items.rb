FactoryBot.define do
  factory :cart_item do
    book
    user
    quantity { 1 }
  end
end
