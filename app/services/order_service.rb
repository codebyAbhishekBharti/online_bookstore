require 'sidekiq/api'

class OrderService
  def self.hello
    "hello from order service"
  end

  def self.create_order(user_id, params)
    cart_ids = params[:cart_ids]
    address_id = params[:address_id]
    raise OrderErrors::MissingParameterError, "Cart IDs and Address ID are required" unless cart_ids && address_id

    address = Address.find_by(id: address_id, user_id: user_id)
    raise OrderErrors::AddressNotFoundError unless address

    cart_items = []
    total_amount = 0

    cart_ids.each do |cart_id|
      cart_item = Cart.find_by(id: cart_id, user_id: user_id)
      raise OrderErrors::CartItemNotFoundError unless cart_item

      book = Book.find_by(id: cart_item.book_id)
      raise OrderErrors::BookNotFoundError unless book

      total_amount += book.price * cart_item.quantity
      cart_items << {
        id: cart_item.id,
        book_id: cart_item.book_id,
        quantity: cart_item.quantity,
        price: book.price
      }
    end

    begin
      ActiveRecord::Base.transaction do
        shipment_address = ShipmentAddressService.create_address(address)
        raise OrderErrors::ShipmentAddressCreationError unless shipment_address

        order = Order.create!(
          user_id: user_id,
          shipment_address_id: shipment_address.id,
          total_amount: total_amount,
          status: "pending"
        )

        cart_items.each do |item|
          OrderItemsService.create_order_item(user_id, {
            order_id: order.id,
            book_id: item[:book_id],
            quantity: item[:quantity]
          })
        end

        cart_items.each do |item|
          book = Book.find_by(id: item[:book_id])
          raise OrderErrors::BookNotFoundError unless book
          book.stock_quantity -= item[:quantity]
          book.save!
        end

        cart_items.each do |item|
          CartsService.delete_cart_item(user_id, { id: item[:id] })
        end

        if Sidekiq::Queue.new("default").size <= 500
          OrderConfirmationEmailJob.perform_later(user_id, {
            order_id: order.id,
            total_amount: total_amount,
            shipment_address: address.slice(:full_name, :phone_number, :address_line1, :address_line2, :city, :state, :zip_code, :country),
            order_items: cart_items.map { |item| item.slice(:book_id, :quantity, :price) }
          })
        else
          self.send_order_confirmation_email(user_id, params)
        end

        order
      end
    rescue => e
      raise OrderErrors::OrderCreationError, e.message
    end
  end

  def self.send_order_confirmation_email(user_id, params)
    user = User.find_by(id: user_id)
    raise OrderErrors::UserNotFoundError unless user
    OrderMailer.order_confirmation_email(user.email, params).deliver_now
  end

  def self.get_all_orders(user_id)
    orders = Order.where(user_id: user_id)
    raise OrderErrors::OrdersNotFoundError if orders.blank?
    orders
  end

  def self.get_order_details(user_id, order_id)
    order = Order.find_by(id: order_id, user_id: user_id)
    raise OrderErrors::OrderNotFoundError unless order
    order
  end

  def self.update_order_address(user_id, params)
    order = self.get_order_details(user_id, params[:order_id])
    ShipmentAddressService.update_address(order.shipment_address_id, params)
  rescue => e
    raise OrderErrors::OrderUpdateError, e.message
  end

  def self.delete_order(user_id, order_id)
    order = self.get_order_details(user_id, order_id)

    raise OrderErrors::OrderDeletionForbiddenError if order.status.in?(%w[shipped delivered])

    begin
      ActiveRecord::Base.transaction do
        order_items = OrderItemsService.get_order_items_by_order_id(order.id)
        order_items.each do |order_item|
          book = Book.find_by(id: order_item.book_id)
          book.stock_quantity += order_item.quantity if book
          book&.save!
          OrderItemsService.delete_order_item(order_item.id)
        end

        order.destroy!
        ShipmentAddressService.delete_address(order.shipment_address_id)
      end
    rescue => e
      raise OrderErrors::OrderDeletionError, e.message
    end

    order
  end
end
