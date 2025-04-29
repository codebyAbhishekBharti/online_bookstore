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

      desc "Delete a book"
      before do
        require_vendor!
      end
      params do
        requires :id, type: Integer, desc: "Book ID"
      end
      delete do
        response = BookService.delete_book(current_user.id, params)
        if response
          present :status, :success
          present :data, response
        else
          error!({ status: :failed, message: "Unable to delete book", error: "Delete operation failed" }, 500)
        end
      rescue ActiveRecord::RecordNotFound => e
        error!({ status: :failed, message: "Book not found", error: e.message }, 404)
      rescue ActiveRecord::RecordInvalid => e
        error!({ status: :failed, message: "Failed to delete book", error: e.message }, 422)
      rescue StandardError => e
        error!({ status: :failed, message: "An error occurred", error: e.message }, 500)
      end

      desc "Get all books"
      before do
        authenticate_user!
      end
      get do
        response = BookService.get_all_books
          present :status, :success
          present :data, response
      rescue => e
          error!({ status: :failed, message: "Unable to fetch data from DB", error: e }, 500)
      end

      desc "Search books"
      before do
        authenticate_user!
      end
      params do
        optional :title, type: String, desc: "Book title"
        optional :author, type: String, desc: "Book author"
        optional :category, type: String, desc: "Book category"
      end
      post :search do
        puts "Search parameters: #{params.inspect}"
        if params[:title].blank? && params[:author].blank? && params[:category].blank?
          error!({ status: :failed, message: "At least one search parameter (title, author, category) is required" }, 400)
        end

        response = BookService.search_books(params)

        if response.present?
          present :status, :success
          present :data, response
        else
          error!({ status: :failed, message: "No books found matching criteria" }, 404)
        end
      rescue => e
        error!({ status: :failed, message: "Error while searching books", error: e.message }, 500)
      end
    end
  end
end
