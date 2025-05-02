class OrderItemsService
  def hello
    "hello from order item service"
  end

  def self.create_order_item(user_id, params)
    order_id = params[:order_id]
    book_id = params[:book_id]
    quantity = params[:quantity]
    raise ActiveRecord::RecordNotFound, "Order ID, Book ID and quantity are required" unless order_id && book_id && quantity
    raise ActiveRecord::RecordNotSaved, "Quantity must be a positive integer" unless quantity.is_a?(Integer) && quantity > 0
    raise ActiveRecord::RecordNotFound, "User ID is required" unless user_id

    # Check stock
    book = Book.find_by(id: book_id)
    raise ActiveRecord::RecordNotFound, "Book not found" unless book
    raise ActiveRecord::RecordNotSaved, "Not enough stock available" if book.stock_quantity < quantity

    # Create order item
    order_item = OrderItem.create!(
      order_id: order_id,
      book_id: book_id,
      quantity: quantity,
      price: book.price
    )
    order_item
  end

  def self.create_order_item_without_cart(user_id, params)
    order_id = params[:order_id]
    book_id = params[:book_id]
    quantity = params[:quantity]
    raise "Order ID, Book ID and quantity are required" unless order_id && book_id && quantity
    raise "Quantity must be a positive integer" unless quantity.is_a?(Integer) && quantity > 0
    raise "User ID is required" unless user_id

    book = Book.find_by(id: book_id)
    raise "Book not found" unless book
    raise "Not enough stock available" if book.stock_quantity < quantity

    order_item = OrderItem.create!(
      order_id: order_id,
      book_id: book_id,
      quantity: quantity,
      price: book.price
    )
    order_item
  end

  def self.get_all_order_items(user_id)
    OrderItem.all
  end

  def self.get_order_items_by_order_id(order_id)
    order_items = OrderItem.where(order_id: order_id)
    order_items
  end

  def self.get_order_item(order_item_id)
    order_items = OrderItem.where(order_id: order_item_id)
    raise ActiveRecord::RecordNotFound, "Order item not found" if order_items.blank?
    {status: :success, data: order_items}
  end

  def self.delete_order_item(order_item_id)
    raise ErrorHandler::MissingParameterError, "Order Item ID is required" unless order_item_id

    order_item = OrderItem.find_by(id: order_item_id)
    raise ActiveRecord::RecordNotFound, "Order item not found" unless order_item

    order_item.destroy
  end

  def self.update_order_item(user_id, params)
    order_item_id = params[:id]
    new_quantity = params[:quantity]
    raise "Order Item ID and new quantity are required" unless order_item_id && new_quantity
    raise "New quantity must be a positive integer" unless new_quantity.is_a?(Integer) && new_quantity > 0

    order_item = OrderItem.find_by(id: order_item_id, user_id: user_id)
    raise "Order item not found" unless order_item
    raise "Not enough stock available" if order_item.book.stock_quantity < new_quantity

    order_item.update!(quantity: new_quantity)
    order_item
  end
end