# Define custom error class
class MissingParameterError < StandardError; end

module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      error!({
        status: "failed",
        message: e.message,
        error: (e.cause&.message || e.message)
      }, 404)
    end

    rescue_from PG::UniqueViolation do |e|
      error!({
        status: "failed",
        message: e.message,
        error: (e.cause&.message || e.message)
      }, 409) # 409 Conflict is more semantically correct
    end

    rescue_from ActiveRecord::RecordNotSaved do |e|
      error!({
        status: "failed",
        message: e.message,
        error: (e.cause&.message || e.message)
      }, 422)
    end

    rescue_from MissingParameterError do |e|
      error!({
        status: "failed",
        message: e.message,
        error: (e.cause&.message || e.message)
      }, 422)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      error!({
        status: "failed",
        message: e.message,
        error: (e.cause&.message || e.message)
      }, 422)
    end

    rescue_from ActiveRecord::RecordNotDestroyed do |e|
      error!({
        tatus: "failed",
        message: e.message,
        error: (e.cause&.message || e.message)
      },422)
    end

    rescue_from :all do |e|
      error!({
        status: "failed",
        message: "Internal server error",
        error: "#{e.class}: #{e.cause&.message || e.message}"
      }, 500)
    end
  end
end
