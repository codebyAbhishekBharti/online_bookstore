# app/api/v1/order.rb
module V1
  class Order < Grape::API
    helpers AuthHelper

    resource :order do
      before do
        authenticate_user!
      end

      desc "Create a new order"
      params do
        requires :cart_ids, type: Array, desc: "Cart IDs"
        requires :address_id, type: Integer, desc: "Address ID"
      end
      post do
        response = OrderService.create_order(current_user.id, params)
        present :status, :success
        present :data, response
      end

      desc "Get all orders for the user"
      get do
        response = OrderService.get_all_orders(current_user.id)
        present :status, :success
        present :data, response
      end

      desc "Get order details by ID"
      params do
        requires :id, type: Integer, desc: "Order ID"
      end
      get ':id' do
        response = OrderService.get_order_details(current_user.id, params[:id])
        present :status, :success
        present :data, response
      end

      desc "Update order address"
      params do
        requires :order_id, type: Integer, desc: "Order ID"
        optional :full_name, type: String, desc: "Full name of the user"
        optional :phone_number, type: String, desc: "Phone number of the user"
        optional :address_line1, type: String, desc: "Address line 1"
        optional :address_line2, type: String, desc: "Address line 2"
        optional :city, type: String, desc: "City"
        optional :state, type: String, desc: "State"
        optional :zip_code, type: String, desc: "Zip code"
        optional :country, type: String, desc: "Country"
      end
      patch ':order_id' do
        response = OrderService.update_order_address(current_user.id, params)
        present :status, :success
        present :data, response
      end

      desc "Delete an order"
      params do
        requires :order_id, type: Integer, desc: "Order ID"
      end
      delete ':order_id' do
        response = OrderService.delete_order(current_user.id, params[:order_id])
        present :status, :success
        present :data, response
      end
    end
  end
end