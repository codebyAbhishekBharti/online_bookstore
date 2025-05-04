require 'json_web_token'

module V1
  class Auth < Grape::API
    helpers AuthHelper
    resource :auth do
      desc "Login User and return JWT token"
      params do
        requires :email, type: String, desc: "User email"
        requires :password, type: String, desc: "User password"
      end
      post :login do
        user = User.find_by(email: params[:email])

        if user && user.authenticate(params[:password])
          token = JsonWebToken.encode({id: user.id, email: user.email,role: user.role})
          { status: :success, token: token, user: { id: user.id, name: user.name, email: user.email, role: user.role } }
        else
          raise UnauthorizedError, "Invalid email or password"
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
          raise ActiveRecord::RecordInvalid, "User creation failed"
        end
      end

      before do
        authenticate_user!
      end
      get :me do
        user = current_user
        if user
          present :status, :success
          present :data, user
        else
          raise ActiveRecord::RecordNotFound, "User not found"
        end
      end
    end
  end
end