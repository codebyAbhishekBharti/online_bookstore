class EmailService
  def self.send_email(to, subject, body)
    # Logic to send a single email
    puts "Sending email to #{to} with subject '#{subject}' and body '#{body}'"
    # Here you would integrate with an email service provider
  end

  def self.send_bulk_email(recipients, subject, body)
    # Logic to send bulk emails
    recipients.each do |recipient|
      send_email(recipient, subject, body)
    end
  end
end