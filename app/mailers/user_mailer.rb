class UserMailer < ApplicationMailer
  default from: 'no-reply@bookstore.com'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Bookstore!')
  end
end
