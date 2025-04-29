
module V1
  class BookApi < Grape::API
    version 'v1', using: :path  # Add versioning
    format :json
    resource :book do
      desc "Entry a new book"
      params do
      end
      post do
        "kaam kar raha hai bhai"
      end
    end
  end
end