# app/api/errors/auth_errors.rb

module AuthErrors
  class UnauthorizedError < BaseError
    def initialize(msg = "Unauthorized")
      super(msg, status: 401)
    end
  end

  class InvalidCredentialsError < BaseError
    def initialize(msg = "Invalid email or password")
      super(msg, status: 401)
    end
  end

  class RecordNotFoundError < BaseError
    def initialize(msg = "Record not found")
      super(msg, status: 404)
    end
  end

  class RecordNotSavedError < BaseError
    def initialize(msg = "Record not saved")
      super(msg, status: 422)
    end
  end

  class InvalidTokenError < BaseError
    def initialize(msg = "Invalid token")
      super(msg, status: 401)
    end
  end

  class ExpiredTokenError < BaseError
    def initialize(msg = "Expired token")
      super(msg, status: 401)
    end
  end

  class TokenNotFoundError < BaseError
    def initialize(msg = "Token not found")
      super(msg, status: 404)
    end
  end

end
