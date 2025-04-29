require_relative "../../lib/json_web_tokeb"

class AuthAPI < Grape::API
  resource :auth do
    desc "Login User and return JWT token"
    params do
      requires :email, type: String, desc: "User email"
      requires :password, type: String, desc: "User password"
    end
    post :login do
      user = User.find_by(email: params[:email])
      # return user
      if user && user.authenticate(params[:password])
        token = JsonWebToken.encode(user_id: user.id)
        { status: :success, token: token, user: { id: user.id, email: user.email, role: user.role } }
      else
        error!({ status: :failed, message: "Invalid email or password" }, 401)
      end
    end
    desc "Create User and return JWT token"
    params do
      requires :name, type: String, desc: "User name"
      requires :email, type: String, desc: "User email"
      requires :password, type: String, desc: "User password"
      requires :phone_number, type: String, desc: "User phone number"
      requires :address, type: String, desc: "User address"
      requires :role, type: String, desc: "User role (e.g., admin, user)"
    end
    post :signup do
      user = UserService.create_new_user(params)
      if user && user.authenticate(user.password)
        token = JsonWebToken.encode(user_id: user.id)
        { status: :success, token: token, user: user }
      else
        error!({ status: :failed, message: "Missing fields" }, 401)
      end
    rescue => e
      error!({ status: :failed, message: "Unable to create new user", error: e.message }, 409)
    end
  end
end
