class OrderMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.order_confirmation.subject
  #
  default from: 'no-reply@bookstore.com'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Bookstore!')
  end

  def order_confirmation_email(user_email, params)
    @user_email = user_email
    @order_id = params[:order_id]
    @total_price = params[:total_amount]
    @shipment_address = params[:shipment_address]
    @order_items = params[:order_items]

    mail(to: @user_email, subject: 'Order Confirmation')
  end
end
