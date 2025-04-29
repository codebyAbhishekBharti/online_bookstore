
module V2
  class BookApi < Grape::API
    version "v2", using: :path  # Add versioning
    format :json

    resource :book do
      desc "Entry a new book"
      params do
      end
      post do
        V2::BookService.hello
      end
    end
  end
end
