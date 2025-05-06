class CartsService
  def self.hello
    "hello from carts service"
  end

  def self.add_item_to_cart(user_id, params)
    book_id = params[:book_id]
    quantity = params[:quantity]
    
    raise CartErrors::MissingParameterError, "User ID is required" unless user_id
    raise CartErrors::MissingParameterError, "Book ID and quantity are required" unless book_id && quantity
    raise CartErrors::InvalidQuantityError unless quantity.is_a?(Integer) && quantity > 0

    book = BookService.get_book_by_id(book_id)
    raise CartErrors::InsufficientStockError if book.stock_quantity < quantity

    cart_item = Cart.create!(user_id: user_id, book_id: book_id, quantity: quantity)
    cart_item
  rescue ActiveRecord::RecordNotUnique => e
    raise CartErrors::CartItemAlreadyExistsError, "Item already exists in cart"
  rescue ActiveRecord::RecordInvalid => e
    raise CartErrors::CartOperationFailedError, e.message
  end

  def self.get_cart_items(user_id)
    cart_items = Cart.where(user_id: user_id)
    raise CartErrors::CartItemNotFoundError, "No items found" if cart_items.blank?
    cart_items
  end

  def self.delete_cart_item(user_id, params)
    cart_item_id = params[:id]
    raise CartErrors::MissingParameterError, "Cart Item ID is required" unless cart_item_id
  
    cart_item = Cart.find_by(id: cart_item_id, user_id: user_id)
    raise CartErrors::CartItemNotFoundError, "Cart item not found" unless cart_item
  
    cart_item.destroy
    cart_item
  rescue CartErrors::CartItemNotFoundError => e
    raise e  # Re-raise the specific error
  rescue => e
    raise CartErrors::CartOperationFailedError, e.message  # Generic error handling
  end
  

  def self.update_cart_item(user_id, params)
    cart_item_id = params[:id]
    new_quantity = params[:quantity]
  
    raise CartErrors::MissingParameterError, "Cart Item ID and quantity are required" unless cart_item_id && new_quantity
    raise CartErrors::InvalidQuantityError unless new_quantity.is_a?(Integer) && new_quantity > 0
  
    cart_item = Cart.includes(:book).find_by(id: cart_item_id, user_id: user_id)
    raise CartErrors::CartItemNotFoundError, "Cart item not found" unless cart_item
    raise CartErrors::BookNotFoundError, "Associated book not found" unless cart_item.book
  
    available_stock = cart_item.book.stock_quantity
    raise CartErrors::InsufficientStockError, "Only #{available_stock} in stock" if new_quantity > available_stock
  
    cart_item.update!(quantity: new_quantity)
    cart_item
  rescue ActiveRecord::RecordInvalid => e
    raise CartErrors::CartOperationFailedError, e.message
  end
end
