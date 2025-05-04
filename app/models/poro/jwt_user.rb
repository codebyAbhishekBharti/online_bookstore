# app/models/poro/jwt_user.rb
class JwtUser
  attr_reader :id, :email, :role

  def initialize(payload)
    @id = payload['user_id']
    @email = payload['email']
    @role = payload['role']
  end

  def vendor?
    role == 'vendor'
  end

  def customer?
    role == 'customer'
  end

  def admin?
    role == 'admin'
  end
end
