class SendWelcomeEmailService
  def initialize(user)
    @user = user
  end

  def call
    UserMailer.welcome_email(@user).deliver_now
  end
end
