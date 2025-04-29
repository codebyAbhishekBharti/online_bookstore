# app/api/v1/book_api.rb
module V1
  class BookApi < Grape::API
    version "v1", using: :path  # Add versioning
    format :json
    resource :book do
      desc "Entry a new book"
      params do
        requires :title, type: String, desc: "User title"
        requires :author, type: String, desc: "User author"
        requires :price, type: String, desc: "User email"
        requires :description, type: String, desc: "User email"
        requires :stock_quantity, type: String, desc: "User email"
        requires :category_name, type: String, desc: "User email"
      end
      post do
        V1::BookService.hello
      end
    end
  end
end
