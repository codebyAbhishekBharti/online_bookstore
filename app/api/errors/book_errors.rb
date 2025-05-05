# app/api/errors/book_errors.rb

module BookErrors
  class InvalidParametersError < BaseError
    def initialize(msg = "Invalid parameters")
      super(msg, status: 422)
    end
  end

  class BookNotFoundError < BaseError
    def initialize(msg = "Book not found")
      super(msg, status: 404)
    end
  end

  class AccessDeniedError < BaseError
    def initialize(msg = "Access denied to this book")
      super(msg, status: 403)
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

  class DuplicateRecordError < BaseError
    def initialize(msg = "Record already exists")
      super(msg, status: 409)
    end
  end

  class RecordNotFound < BaseError
    def initialize(msg = "Record not found")
      super(msg, status: 404)
    end
  end

  class InvalidBookError < BaseError
    def initialize(msg = "Invalid book")
      super(msg, status: 422)
    end
  end

  class BookAlreadyExistsError < BaseError
    def initialize(msg = "Book already exists")
      super(msg, status: 409)
    end
  end

  class BookNotAvailableError < BaseError
    def initialize(msg = "Book not available")
      super(msg, status: 422)
    end
  end
end
