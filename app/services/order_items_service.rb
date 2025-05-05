class OrderItemsService
  def self.hello
    "hello from order item service"
  end

  def self.create_order_item(user_id, params)
    order_id = params[:order_id]
    book_id = params[:book_id]
    quantity = params[:quantity]

    raise OrderItemErrors::MissingParameterError, "Order ID, Book ID and quantity are required" unless order_id && book_id && quantity
    raise OrderItemErrors::InvalidQuantityError unless quantity.is_a?(Integer) && quantity > 0
    raise OrderItemErrors::MissingParameterError, "User ID is required" unless user_id

    book = BookService.get_book_by_id(book_id)
    raise OrderItemErrors::InsufficientStockError if book.stock_quantity < quantity

    begin
      order_item = OrderItem.create!(
        order_id: order_id,
        book_id: book_id,
        quantity: quantity,
        price: book.price
      )
    rescue ActiveRecord::RecordInvalid => e
      raise OrderItemErrors::OrderItemCreationError, e.message
    end

    order_item
  end

  def self.get_all_order_items(user_id)
    OrderItem.all
  end

  def self.get_order_items_by_order_id(order_id)
    raise OrderItemErrors::MissingParameterError, "Order ID is required" unless order_id
    OrderItem.where(order_id: order_id)
  end

  def self.get_order_item(order_item_id)
    raise OrderItemErrors::MissingParameterError, "Order Item ID is required" unless order_item_id
    OrderItem.where(order_id: order_item_id)
  end

  def self.delete_order_item(order_item_id)
    raise OrderItemErrors::MissingParameterError, "Order Item ID is required" unless order_item_id

    order_item = OrderItem.find_by(id: order_item_id)
    raise OrderItemErrors::OrderItemNotFoundError unless order_item

    order_item.destroy
  end

  def self.update_order_item(user_id, params)
    order_item_id = params[:id]
    new_quantity = params[:quantity]
  
    raise OrderItemErrors::MissingParameterError, "Order Item ID and new quantity are required" unless order_item_id && new_quantity
    raise OrderItemErrors::InvalidQuantityError unless new_quantity.is_a?(Integer) && new_quantity > 0
  
    order_item = OrderItem.find_by(id: order_item_id, user_id: user_id)
    raise OrderItemErrors::OrderItemNotFoundError unless order_item
  
    book = order_item.book
    quantity_difference = new_quantity - order_item.quantity
  
    if quantity_difference > 0 && book.stock_quantity < quantity_difference
      raise OrderItemErrors::InsufficientStockError, "Only #{book.stock_quantity} units available"
    end
  
    begin
      order_item.update!(quantity: new_quantity)
    rescue ActiveRecord::RecordInvalid => e
      raise OrderItemErrors::OrderItemUpdateError, e.message
    end
  
    order_item
  end
end
