module V1
  class OrderItems < Grape::API
    helpers AuthHelper
    before do
      authenticate_user!
    end
    resource :order_items do
      desc "Create a new order item"
      params do
        requires :order_group_id, type: Integer, desc: "Order ID"
        requires :book_id, type: Integer, desc: "Book ID"
        requires :quantity, type: Integer, desc: "Quantity of the book"
      end
      post do
        response = OrderItemsService.create_order_item(current_user.id, params)
        if response
          present :status, :success
          present :data, response
        else
          error!({ status: :failed, message: "Unable to create order item", error: "Order item creation failed" }, 500)
        end
      end

      desc "Get all order items"
      get do
        response = OrderItemsService.get_all_order_items(current_user.id)
        if response
          present :status, :success
          present :data, response
        else
          error!({ status: :failed, message: "Unable to fetch order items", error: "No items found" }, 404)
        end
      rescue => e
        error!({ status: :failed, message: "Unable to fetch order items", error: e.message }, 409)
      end

      desc "Get order item details"
      params do
        requires :id, type: Integer, desc: "Order Item ID"
      end
      get ':id' do
        response = OrderItemsService.get_order_item_details(current_user.id, params[:id])
        if response
          present :status, :success
          present :data, response
        else
          error!({ status: :failed, message: "Unable to fetch order item details", error: "Item not found" }, 404)
        end
      rescue => e
        error!({ status: :failed, message: "Unable to fetch order item details", error: e.message }, 409)
      end

    end
  end
end