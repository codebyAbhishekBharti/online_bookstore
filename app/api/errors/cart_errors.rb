# app/api/errors/cart_errors.rb

module CartErrors
  class BaseError < StandardError
    attr_reader :status

    def initialize(msg = "Cart error", status: 400)
      @status = status
      super(msg)
    end
  end

  class MissingParameterError < BaseError
    def initialize(msg = "Missing required parameter")
      super(msg, status: 422)
    end
  end

  class InvalidQuantityError < BaseError
    def initialize(msg = "Invalid quantity")
      super(msg, status: 422)
    end
  end

  class BookNotFoundError < BaseError
    def initialize(msg = "Book not found")
      super(msg, status: 404)
    end
  end

  class InsufficientStockError < BaseError
    def initialize(msg = "Not enough stock available")
      super(msg, status: 409)
    end
  end

  class CartItemNotFoundError < BaseError
    def initialize(msg = "Cart item not found")
      super(msg, status: 404)
    end
  end

  class CartOperationFailedError < BaseError
    def initialize(msg = "Unable to process cart operation")
      super(msg, status: 409)
    end
  end

  class CartItemAlreadyExistsError < BaseError
    def initialize(msg = "Item already exists in cart")
      super(msg, status: 409)
    end
  end 
end
