# app/errors/shipment_address_errors.rb
module ShipmentAddressErrors
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

  class ShipmentAddressNotFoundError < BaseError
    def initialize(msg = "Shipment address not found")
      super(msg, status: 404)
    end
  end

  class NoAddressesFoundError < BaseError
    def initialize(msg = "No shipment addresses found")
      super(msg, status: 404)
    end
  end

  class ShipmentAddressCreationError < BaseError
    def initialize(msg = "Failed to create shipment address")
      super(msg, status: 500)
    end
  end

  class ShipmentAddressUpdateError < BaseError
    def initialize(msg = "Failed to update shipment address")
      super(msg, status: 409)
    end
  end

  class ShipmentAddressDeletionError < BaseError
    def initialize(msg = "Failed to delete shipment address")
      super(msg, status: 422)
    end
  end
end
