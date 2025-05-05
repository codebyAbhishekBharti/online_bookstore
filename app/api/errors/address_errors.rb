# app/api/errors/address_errors.rb

module AddressErrors
  class BaseError < StandardError
    attr_reader :status

    def initialize(message = nil, status: 400)
      super(message)
      @status = status
    end
  end

  class MissingParameterError < BaseError
    def initialize(msg = "Missing required parameter")
      super(msg, status: 422)
    end
  end

  class AddressNotFoundError < BaseError
    def initialize(msg = "Address not found")
      super(msg, status: 404)
    end
  end

  class UnauthorizedAccessError < BaseError
    def initialize(msg = "You are not authorized to access this address")
      super(msg, status: 403)
    end
  end

  class AddressOperationFailedError < BaseError
    def initialize(msg = "Address operation failed")
      super(msg, status: 409)
    end
  end
end
