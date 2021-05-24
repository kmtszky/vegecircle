class Customers::WelcomeMailer < ApplicationMailer

  def complete_registration(customer)
    @customer = customer
    @url = "http://vegecircle.com/customers/sign_in"
    mail(to: customer.email, subject: '【vegecircle】ご登録完了のお知らせ')
  end
end
