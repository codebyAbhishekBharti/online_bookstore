# app/api/helpers/auth_helper.rb
module AuthHelper
  def current_user
    return @current_user if defined?(@current_user)

    token = headers['Authorization']&.split(' ')&.last
    @current_user = nil
    if token
      decoded = JsonWebToken.decode(token)
      @current_user = User.find_by(id: decoded[:user_id]) if decoded
    end
    @current_user
  end

  def authenticate_user!
    error!({ status: :failed, message: 'Unauthorized Access' }, 401) unless current_user
  end

  def require_vendor!
    unless current_user
      error!({ status: :unauthorized, message: "Unauthorized" }, 401)
    end

    unless current_user.role == "vendor"
      error!({ status: :unauthorized, message: "Access restricted to vendors only" }, 403)
    end
  end
end
