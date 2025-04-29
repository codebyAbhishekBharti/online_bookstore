# app/api/helpers/auth_helper.rb
module AuthHelper
  def current_user
    token = headers['Authorization']&.split(' ')&.last
    return nil unless token

    decoded = JsonWebToken.decode(token)
    @current_user ||= User.find_by(id: decoded[:user_id]) if decoded
  end

  def authenticate_user!
    error!({ status: :failed, message: 'Unauthorized Access' }, 401) unless current_user
  end

  def require_vendor!
    error!({ status: :unauthorized, message: "Access restricted to vendors only" }, 403) unless current_user.role == "vendor"
  end
end
