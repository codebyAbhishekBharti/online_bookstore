module OrderItemErrors
  class BaseError < StandardError
    attr_reader :status

    def initialize(message = nil, status: 400)
      @status = status
      super(message)
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

  class OrderItemNotFoundError < BaseError
    def initialize(msg = "Order item not found")
      super(msg, status: 404)
    end
  end

  class OrderItemCreationError < BaseError
    def initialize(msg = "Failed to create order item")
      super(msg, status: 500)
    end
  end

  class OrderItemUpdateError < BaseError
    def initialize(msg = "Failed to update order item")
      super(msg, status: 500)
    end
  end
end
