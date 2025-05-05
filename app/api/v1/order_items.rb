module V1
  class OrderItems < Grape::API
    helpers AuthHelper
    before do
      authenticate_user!
    end

    resource :order_items do
      desc "Create a new order item"
      params do
        requires :order_id, type: Integer, desc: "Order ID"
        requires :book_id, type: Integer, desc: "Book ID"
        requires :quantity, type: Integer, desc: "Quantity of the book"
      end
      post do
        response = OrderItemsService.create_order_item(current_user.id, params)
        present :status, :success
        present :data, response
      end

      desc "Get all order items"
      get do
        response = OrderItemsService.get_all_order_items(current_user.id)
        present :status, :success
        present :data, response
      end

      desc "Get order item details"
      params do
        requires :id, type: Integer, desc: "Order Item ID"
      end
      get ':id' do
        response = OrderItemsService.get_order_item(params[:id])  # Updated to use order item id directly
        present :status, :success
        present :data, response
      end
    end
  end
end