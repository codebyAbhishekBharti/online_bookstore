# app/api/users_api.rb
require_relative "helpers/auth_helper"

class UsersAPI < Grape::API
  helpers AuthHelper

  resource :users do
    desc "Create new user (No authentication required)"
    post do
      response = UserService.create_new_user(params)
      present :status, :success
      present :data, response
    rescue => e
      error!({ status: :failed, message: "Unable to create new user", error: e.message }, 409)
    end

    desc "Get all users (Authentication required)"
    before do
      authenticate_user!
    end
    get do
      response = UserService.get_all_users
      if response
        present :status, :success
        present :data, response
      else
        error!({ status: :failed, message: "Unable to fetch data from DB", error: "Unable to fetch data from DB" }, 500)
      end
    end
  end
end
