module V1
  class Email < Grape::API
    resource :email do
      desc "Send email"
      params do
        requires :to, type: String, desc: "Recipient email address"
      end
      post do
        puts params[:to]
        user = User.find_by(email: params[:to])
        error!('User not found', 404) unless user

        SendWelcomeEmailService.new(user).call
        { message: 'Email sent successfully' }
        # EmailService.send_email(params[:to], params[:subject], params[:body])
        # { status: :success, message: "Email sent successfully" }
      end

      desc "Send bulk email"
      params do
        requires :to, type: Array[String], desc: "List of recipient email addresses"
        requires :subject, type: String, desc: "Email subject"
        requires :body, type: String, desc: "Email body"
      end
      post :bulk do
        EmailService.send_bulk_email(params[:to], params[:subject], params[:body])
        { status: :success, message: "Bulk email sent successfully" }
      end
    end
  end
end