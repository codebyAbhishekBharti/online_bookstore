# app/api/v1/base.rb
module V1
  class Base < Grape::API
    version 'v1', using: :path
    format :json
    
    mount V1::Auth
    mount V1::Users
    mount V1::Book
    mount V1::Carts
    mount V1::Address
    mount V1::ShipmentAddress
  end
end
