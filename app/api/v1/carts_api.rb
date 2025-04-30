require 'json_web_token'

module V1
  class CartsApi < Grape::API
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
        present :status, :success
        present :data, response
      rescue => e
        error!({ status: :failed, message: "Unable to add item to cart", error: e.message }, 409)
      end

      desc "Get all items in the cart"
      before do
        authenticate_user!
      end
      get do
        response = CartsService.get_cart_items(current_user.id)
        if response
          present :status, :success
          present :data, response
        else
          error!({ status: :failed, message: "Unable to fetch cart items", error: "No items found" }, 404)
        end
      rescue => e
        error!({ status: :failed, message: "Unable to fetch cart items", error: e.message }, 409)
      end

      desc "Delete an item from the cart"
      before do
        authenticate_user!
      end
      params do
        requires :id, type: Integer, desc: "Cart Item ID"
      end
      delete do
        response = CartsService.delete_cart_item(current_user.id, params)
        if response
          present :status, :success
          present :data, response
        else
          error!({ status: :failed, message: "Unable to delete cart item", error: "Delete operation failed" }, 500)
        end
      rescue => e
        error!({ status: :failed, message: "Unable to delete cart item", error: e.message }, 409)
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