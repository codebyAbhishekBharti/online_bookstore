# app/api/errors/base_error.rb
class BaseError < StandardError
  attr_reader :status

  def initialize(msg = "Something went wrong", status: 500)
    super(msg)
    @status = status
  end
end
