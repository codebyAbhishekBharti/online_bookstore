# app/api/v1/carts_api.rb
module V1
  class Carts < Grape::API
    helpers AuthHelper

    resource :cart do
      desc "Add item to the cart"
      before do
        authenticate_user!
      end
      params do
        requires :book_id, type: Integer, desc: "Book ID"
        requires :quantity, type: Integer, desc: "Quantity of the book"
      end
      post do
        response = CartsService.add_item_to_cart(current_user.id, params)
        raise ActiveRecord::RecordNotFound, "Unable to add item to cart" if response.blank?
        present :status, :success
        present :data, response
      end

      desc "Get all items in the cart"
      before do
        authenticate_user!
      end
      get do
        response = CartsService.get_cart_items(current_user.id)
        raise ActiveRecord::RecordNotFound, "No items found" if response.blank?
        present :status, :success
        present :data, response
      end

      desc "Delete an item from the cart"
      before do
        authenticate_user!
      end
      params do
        requires :id, type: Integer, desc: "Cart Item ID"
      end
      delete do
        CartsService.delete_cart_item(current_user.id, params)
      end

      desc "Update an item in the cart"
      before do
        authenticate_user!
      end
      params do
        requires :id, type: Integer, desc: "Cart Item ID"
        requires :quantity, type: Integer, desc: "New quantity of the book"
      end
      patch do
        response = CartsService.update_cart_item(current_user.id, params)
        if response
          present :status, :success
          present :data, response
        else
          error!({ status: :failed, message: "Unable to update cart item", error: "Update operation failed" }, 500)
        end
      rescue => e
        error!({ status: :failed, message: "Unable to update cart item", error: e.message }, 409)
      end
    end
  end
end