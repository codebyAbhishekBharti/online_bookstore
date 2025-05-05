class AuthService
  def self.hello
    "hello from auth service"
  end

  def self.login(params)
    email = params[:email]
    password = params[:password]
    raise "Email and password cannot be empty" if email.empty? || password.empty?

    # Find the user by email
    user = User.find_by(email: email)
    raise AuthErrors::RecordNotFoundError, "User not found" unless user

    # Check if the user exists and the password is correct
    if user && user.authenticate(password)
      # Generate a JWT token
      token = JsonWebToken.encode({id: user.id, email: user.email,role: user.role})
      return { token: token, user: user }
    else
      raise AuthErrors::UnauthorizedError, "Invalid email or password"
    end
  end

  def self.signup(params)
    user = UserService.create_new_user(params)
    if user && user.authenticate(user.password)
      token = JsonWebToken.encode({ id: user.id, email: user.email, role: user.role })
      return { status: :success, token: token, user: user }
    else
      raise ActiveRecord::RecordNotSavedError, "User creation failed"
    end
  end
end