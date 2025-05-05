require "json_web_token"

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
        response = AuthService.login(params)
        present({ status: "success", data: { token: response[:token], user: response[:user] } })
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
        response = AuthService.signup(params)
        present({ status: "success", data: { token: response[:token], user: response[:user] } })
      end

      before do
        authenticate_user!
      end
      get :me do
        user = UserService.get_user_by_id(current_user.id)
          present :status, :success
          present :data, user
      end
    end
  end
end
