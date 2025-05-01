class OrderService
  def self.hello
    "hello from order service"
  end

  def self.create_order(user_id, params)
    cart_ids = params[:cart_ids]
    address_id = params[:address_id]
    raise ActiveRecord::RecordNotFound, "Cart IDs and Address ID are required" unless cart_ids && address_id
  
    address = Address.find_by(id: address_id, user_id: user_id)
    raise ActiveRecord::RecordNotFound, "Address not found" unless address
  
    cart_items = []
    total_amount = 0
  
    cart_ids.each do |cart_id|
      cart_item = Cart.find_by(id: cart_id, user_id: user_id)
      raise ActiveRecord::RecordNotFound, "Cart item not found" unless cart_item
  
      book = Book.find_by(id: cart_item.book_id)
      raise ActiveRecord::RecordNotFound, "Book not found" unless book
  
      total_amount += book.price * cart_item.quantity
      cart_items << {
        id: cart_item.id,
        book_id: cart_item.book_id,
        quantity: cart_item.quantity,
        price: book.price
      }
    end
  
    ActiveRecord::Base.transaction do
      # Create shipment address (assume this is a DB write)
      shipment_address = ShipmentAddressService.create_address(address)
      raise ActiveRecord::RecordNotFound, "Shipment address not found" unless shipment_address
  
      # Create the order
      order = Order.create!(
        user_id: user_id,
        shipment_address_id: shipment_address.id,
        total_amount: total_amount,
        status: "pending"
      )
  
      # Create order items
      cart_items.each do |item|
        OrderItemsService.create_order_item(user_id, {
          order_group_id: order.order_group_id,
          book_id: item[:book_id],
          quantity: item[:quantity]
        })
      end
  
      # Reduce stock quantities
      cart_items.each do |item|
        book = Book.find_by(id: item[:book_id])
        raise ActiveRecord::RecordNotFound, "Book not found" unless book
        book.stock_quantity -= item[:quantity]
        book.save!
      end
  
      # Remove cart items
      cart_items.each do |item|
        CartsService.delete_cart_item(user_id, { id: item[:id] })
      end
  
      return order
    end
  end
  

  def self.get_all_orders(user_id)
    orders = Order.where(user_id: user_id)
    orders
  end

  def self.get_order_details(user_id, order_id)
    order = Order.find_by(id: order_id, user_id: user_id)
    raise ActiveRecord::RecordNotFound, "Order not found" unless order
    order
  end

  def self.update_order_address(user_id, params)
    order = self.get_order_details(user_id, params[:order_id])
    ShipmentAddressService.update_address(order.shipment_address_id, params)
  end

  def self.delete_order(user_id, order_id)
    order = self.get_order_details(user_id, order_id)
    raise ActiveRecord::RecordNotFound, "Order not found" unless order
  
    if order.status == "shipped" || order.status == "delivered"
      raise ActiveRecord::RecordNotSaved, "Cannot delete shipped or delivered orders"
    end
  
    ActiveRecord::Base.transaction do
      order_items = OrderItemsService.get_order_items_by_order_group_id(order.order_group_id)
  
      order_items.each do |order_item|
        book = Book.find_by(id: order_item.book_id)
        if book
          book.stock_quantity += order_item.quantity
          book.save!
        end
        OrderItemsService.delete_order_item(order_item.id)
      end

      order.destroy!
      ShipmentAddressService.delete_address(order.shipment_address_id)
    end
  
    order
  end
  
  
end
