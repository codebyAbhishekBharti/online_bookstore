class OrderItem < ApplicationRecord
  belongs_to :book
  belongs_to :order
end
