class Book < ApplicationRecord
  belongs_to :vendor, class_name: 'User', foreign_key: 'vendor_id'
end
