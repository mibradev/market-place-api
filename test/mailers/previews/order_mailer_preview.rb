# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/order_mailer/send_confirmation
  def send_confirmation
    order = Order.first
    OrderMailer.send_confirmation(order)
  end
end
