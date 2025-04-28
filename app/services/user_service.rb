class UserService
  def self.get_all_users
    User.all  # returns all users in JSON
  end
  
  def self.create_new_user(params)
    # Check if all required params are present
    required_params = [:name, :email, :phone_number, :password, :address, :role]
    missing_params = required_params.select { |param| params[param].nil? }

    if missing_params.any?
      raise "Missing required params: #{missing_params.join(', ')}"
    end

    # Proceed with user creation
    user = User.create!(
      name: params[:name],
      email: params[:email],
      phone_number: params[:phone_number],
      password_digest: params[:password],  # Ensure you're handling password hashing correctly
      address: params[:address],
      role: params[:role]
    )
    user  # Return created user object
  end
end
