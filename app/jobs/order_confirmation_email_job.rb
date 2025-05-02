# app/jobs/order_confirmation_email_job.rb
class OrderConfirmationEmailJob < ApplicationJob
  queue_as :default

  def perform(user_id, order_details)
    user = UserService.get_user_by_id(user_id)
    OrderMailer.order_confirmation_email(user.email, order_details).deliver_later
  end
end
