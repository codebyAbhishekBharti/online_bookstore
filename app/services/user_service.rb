class UserService
  def self.get_all_users
    User.all  # returns all users in JSON
  end

  def self.create_new_user(params)
    begin
      # Check if all required params are present
      required_params = [ :name, :email, :phone_number, :password, :address, :role ]
      missing_params = required_params.select { |param| params[param].nil? }

      if missing_params.any?
        raise UserErrors::MissingParamsError, "Missing required params: #{missing_params.join(', ')}"
      end

      # Proceed with user creation
      user = User.create!(
        name: params[:name],
        email: params[:email],
        phone_number: params[:phone_number],
        password: params[:password],  # Ensure you're handling password hashing correctly
        address: params[:address],
        role: params[:role]
      )
      user  # Return created user object
    rescue ActiveRecord::RecordNotUnique => e
      raise UserErrors::DuplicateRecordError, "Email has already been taken"

    rescue StandardError => e
      raise UserErrors::InvalidParameterError, "An unexpected error occurred: #{e.message}"
    end
  end

  def self.update_user_details(user_id, params)
    user = User.find_by(id: user_id)
    raise "User not found" unless user

    # Update user details
    allowed_params = [ :name, :email, :phone_number, :password, :address, :role ]
    filtered_params = params.slice(*allowed_params)

    user.update!(filtered_params)
    user  # Return updated user object
  end

  def self.get_user_by_id(user_id)
    user = User.find_by(id: user_id)
    raise UserErrors::RecordNotFound, "User not found" unless user
    user
  end

end