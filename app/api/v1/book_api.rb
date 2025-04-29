# app/api/v1/book_api.rb
module V1
  class BookApi < Grape::API
    helpers AuthHelper

    resource :book do
      desc "Entry a new book"
      before do
        require_vendor!
      end
      params do
        requires :title, type: String, desc: "User title"
        requires :author, type: String, desc: "User author"
        requires :price, type: String, desc: "User email"
        requires :description, type: String, desc: "User email"
        requires :stock_quantity, type: String, desc: "User email"
        requires :category_name, type: String, desc: "User email"
      end
      post do
        response = BookService.insert_new_book(current_user.id, params)
        present :status, :success
        present :data, response
      rescue => e
        error!({ status: :failed, message: "Unable to create new book", error: e.message }, 409)
      end

      desc "Update book details"
      before do
        require_vendor!
      end
      params do
        requires :id, type: Integer, desc: "Book ID"
        optional :title, type: String, desc: "Book title"
        optional :author, type: String, desc: "Book author"
        optional :price, type: String, desc: "Book price"
        optional :description, type: String, desc: "Book description"
        optional :stock_quantity, type: String, desc: "Book stock quantity"
        optional :category_name, type: String, desc: "Book category name"
      end
      patch do
        response = BookService.update_book_details(current_user.id, params)
        if response
          present :status, :success
          present :data, response
        else
          error!({ status: :failed, message: "Unable to update book details", error: "Update operation failed" }, 500)
        end
      rescue => e
        error!({ status: :failed, message: "Unable to update book details", error: e.message }, 409)
      end

      desc "Get all books"
      before do
        authenticate_user!
      end
      get do
        response = BookService.get_all_books
          present :status, :success
          present :data, response
      end
      rescue => e
          error!({ status: :failed, message: "Unable to fetch data from DB", error: e }, 500)
      end

      
  end
end
