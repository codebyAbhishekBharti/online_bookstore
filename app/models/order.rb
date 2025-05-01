class Order < ApplicationRecord
  belongs_to :user
  belongs_to :shipment_address
end
