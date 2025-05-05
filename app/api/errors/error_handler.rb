# app/api/errors/error_handler.rb
module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from :all do |e|
      status_code = e.respond_to?(:status) ? e.status : 500

      error!({
        status: "failed",
        message: e.message,
        error: e.class.to_s
      }, status_code)
    end
  end
end
