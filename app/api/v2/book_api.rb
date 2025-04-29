
module V2
  class BookApi < Grape::API
    version "v2", using: :path  # Add versioning
    format :json

    resource :book do
      desc "Entry a new book"
      params do
      end
      post do
        "2nd version kaam kar raha hai bhai"
      end
    end
  end
end
