# app/jobs/order_confirmation_email_job.rb
class OrderConfirmationEmailJob < ApplicationJob
  queue_as :default

  def perform(user_id, order_details)
    user = User.find_by(id: user_id)
    raise ActiveRecord::RecordNotFound, "User not found" unless user
    OrderMailer.order_confirmation_email(user.email, order_details).deliver_later
  end
end
