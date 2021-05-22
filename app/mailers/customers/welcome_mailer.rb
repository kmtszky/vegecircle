class Customers::WelcomeMailer < ApplicationMailer

  def complete_registration(customer)
    @customer = customer
    mail(to: customer.email, subject: '【vegecircle】ご登録完了のお知らせ')
  end
end
