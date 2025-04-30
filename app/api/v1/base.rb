# app/api/v1/base.rb
module V1
  class Base < Grape::API
    version 'v1', using: :path
    format :json
    
    mount V1::AuthApi
    mount V1::UsersApi
    mount V1::BookApi
    mount V1::CartsApi
  end
end
