class CartsService
  def self.hello
    "hello from carts service"
  end

  def self.add_item_to_cart(user_id, params)
    book_id = params[:book_id]
    quantity = params[:quantity]
    raise "Book ID and quantity are required" unless book_id && quantity
    raise "Quantity must be a positive integer" unless quantity.is_a?(Integer) && quantity > 0
    raise "User ID is required" unless user_id

    # check if enough stock is available
    book = Book.find_by(id: book_id)
    raise "Book not found" unless book
    raise "Not enough stock available" if book.stock_quantity < quantity

    # Create a new cart item
    cart_item = Cart.create!(
    user_id: user_id,
    book_id: book_id,
    quantity: quantity
  )
  cart_item
  end

  def self.get_cart_items(user_id)
    cart_items = Cart.where(user_id: user_id)
    raise "No items found in the cart" if cart_items.empty?
    cart_items
  end

  def self.delete_cart_item(user_id, params)
    cart_item_id = params[:id]
    raise "Cart Item ID is required" unless cart_item_id

    # Find the cart item
    cart_item = Cart.find_by(id: cart_item_id, user_id: user_id)
    raise "Cart item not found" unless cart_item

    # Delete the cart item
    cart_item.destroy
    cart_item
  end

  def self.update_cart_item(user_id, params)
    cart_item_id = params[:id]
    new_quantity = params[:quantity]
    raise "Cart Item ID and new quantity are required" unless cart_item_id && new_quantity
    raise "New quantity must be a positive integer" unless new_quantity.is_a?(Integer) && new_quantity > 0

    # Find the cart item
    cart_item = Cart.find_by(id: cart_item_id, user_id: user_id)
    raise "Cart item not found" unless cart_item
    raise "Not enough stock available" if cart_item.book.stock_quantity < new_quantity

    # Update the cart item
    cart_item.update!(quantity: new_quantity)
    cart_item
  end
end