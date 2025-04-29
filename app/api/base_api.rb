# app/api/base_api.rb

class BaseApi < Grape::API
  prefix :api
  format :json

  get :hello do
    { message: "Hello from Grape API Root Base!" }
  end

  mount V1::Base
  mount V2::Base
end
