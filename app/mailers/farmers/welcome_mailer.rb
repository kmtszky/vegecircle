class Farmers::WelcomeMailer < ApplicationMailer

  def complete_registration(farmer)
    @farmer = farmer
    @url = new_farmer_session_url(farmer)
    mail(to: farmer.email, subject: '【vegecircle】ご登録完了のお知らせ')
  end
end
