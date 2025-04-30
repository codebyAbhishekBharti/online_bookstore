
module V2
  class Book < Grape::API
    resource :book do
      desc "Entry a new book"
      params do
      end
      post do
        "version 2 book api working"
      end
    end
  end
end
