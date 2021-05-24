class Farmers::WelcomeMailer < ApplicationMailer

  def complete_registration(farmer)
    @farmer = farmer
    @url = "http://vegecircle.com/farmers/sign_in"
    mail(to: farmer.email, subject: '【vegecircle】ご登録完了のお知らせ')
  end
end
