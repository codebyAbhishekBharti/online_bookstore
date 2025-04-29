# app/api/v2/base.rb
module V2
  class Base < Grape::API
    version 'v2', using: :path
    format :json

    mount V2::BookApi
  end
end
