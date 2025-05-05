module OrderErrors
  class BaseError < StandardError
    attr_reader :status

    def initialize(message = nil, status: 400)
      @status = status
      super(message)
    end
  end

  class MissingParameterError < BaseError
    def initialize(msg = "Missing required parameters")
      super(msg, status: 422)
    end
  end

  class AddressNotFoundError < BaseError
    def initialize(msg = "Address not found")
      super(msg, status: 404)
    end
  end

  class CartItemNotFoundError < BaseError
    def initialize(msg = "Cart item not found")
      super(msg, status: 404)
    end
  end

  class BookNotFoundError < BaseError
    def initialize(msg = "Book not found")
      super(msg, status: 404)
    end
  end

  class ShipmentAddressCreationError < BaseError
    def initialize(msg = "Shipment address creation failed")
      super(msg, status: 500)
    end
  end

  class OrderCreationError < BaseError
    def initialize(msg = "Order creation failed")
      super(msg, status: 500)
    end
  end

  class UserNotFoundError < BaseError
    def initialize(msg = "User not found")
      super(msg, status: 404)
    end
  end

  class OrdersNotFoundError < BaseError
    def initialize(msg = "No orders found")
      super(msg, status: 404)
    end
  end

  class OrderNotFoundError < BaseError
    def initialize(msg = "Order not found")
      super(msg, status: 404)
    end
  end

  class OrderUpdateError < BaseError
    def initialize(msg = "Order update failed")
      super(msg, status: 409)
    end
  end

  class OrderDeletionForbiddenError < BaseError
    def initialize(msg = "Cannot delete shipped or delivered orders")
      super(msg, status: 403)
    end
  end

  class OrderDeletionError < BaseError
    def initialize(msg = "Order deletion failed")
      super(msg, status: 500)
    end
  end
end
