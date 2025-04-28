# app/api/base_api.rb
class BaseApi < Grape::API
  format :json
  prefix :api  # So all routes will start with /api

  get :hello do
    { message: 'Hello from Grape API!' }
  end

end