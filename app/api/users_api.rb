class UsersAPI < Grape::API
  resource :users do
    get do
      response = UserService.get_all_users
      if response
        present :status, :success
        present :data, response
      else
        error!({ status: :failed, message: 'Unable to fetch data from DB', error: 'Unable to fetch data from DB' }, 500)
      end
    end
    
    post do
      begin
        response = UserService.create_new_user(params)
        present :status, :success
        present :data, response
      rescue => e  # Catch general errors
        error!({status: :failed, message: "Unable to create new user", error: e.message }, 409)
      end
    end
  end
end
