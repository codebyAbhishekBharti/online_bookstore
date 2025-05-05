# app/api/v1/book.rb
module V1
  class Book < Grape::API
    helpers AuthHelper

    resource :book do
      before do
        authenticate_user!
      end

      desc "Get all books"
      get do
        response = BookService.get_all_books
        raise ActiveRecord::RecordNotFound, "No books found" if response.blank?
          present :status, :success
          present :data, response
      end

      desc "Search books"
      params do
        optional :title, type: String, desc: "Book title"
        optional :author, type: String, desc: "Book author"
        optional :category, type: String, desc: "Book category"
      end
      post :search do
        if params[:title].blank? && params[:author].blank? && params[:category].blank?
          error!({ status: :failed, message: "At least one search parameter (title, author, category) is required" }, 400)
        end

        books = BookService.search_books(params)
        raise ActiveRecord::RecordNotFound, "No books found" if books.blank?
        present :status, :success
        present :data, books
      end
      
      resource :vendor do
        before do
          require_vendor!
        end

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
          response = BookService.insert_new_book(current_user.id, params)
          present :status, :success
          present :data, response
        end

        desc "Update book details"
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
          present :status, :success
          present :data, response
        end

        desc "Delete a book"
        params do
          requires :id, type: Integer, desc: "Book ID"
        end
        delete do
          response = BookService.delete_book(current_user.id, params)
          present :status, :success
          present :data, response
        end
      end
    end
  end
end
