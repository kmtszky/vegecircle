class Farmers::WelcomeMailer < ApplicationMailer

  def complete_registration(farmer)
    @farmer = farmer
    mail(to: farmer.email, subject: '【vegecircle】ご登録完了のお知らせ')
  end
end
