class Customers::WelcomeMailer < ApplicationMailer

  def complete_registration(customer)
    @customer = customer
    @url = new_customer_session_url(customer)
    mail(to: customer.email, subject: '【vegecircle】ご登録完了のお知らせ')
  end
end
