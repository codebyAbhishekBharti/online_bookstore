# app/api/errors/user_errors.rb

module UserErrors
  class RecordNotFound < BaseError
    def initialize(msg = "User not found")
      super(msg, status: 404)
    end
  end

  class DuplicateRecordError < BaseError
    def initialize(msg = "User already exists")
      super(msg, status: 409)
    end
  end

  class MissingParameterError < BaseError
    def initialize(msg = "Missing required parameter")
      super(msg, status: 422)
    end
  end

  class InvalidParameterError < BaseError
    def initialize(msg = "Invalid parameter")
      super(msg, status: 422)
    end
  end

  class AccessDeniedError < BaseError
    def initialize(msg = "Access denied")
      super(msg, status: 403)
    end
  end
end
