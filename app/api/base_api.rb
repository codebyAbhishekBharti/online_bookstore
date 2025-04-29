# app/api/base_api.rb

class BaseApi < Grape::API
  format :json
  prefix :api  # So all routes will start with /api

  get :hello do
    { message: 'Hello from Grape API!' }
  end

  mount V1::AuthApi
  mount V1::UsersApi
  mount V1::BookApi
  mount V2::BookApi
end