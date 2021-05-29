class Farmers::RemindMailer < ApplicationMailer
  def remind_event_schedule(farmer, event, schedule, number_of_people)
    @url = "http://vegecircle.com/farmers/sign_in"
    @farmer = farmer
    @event = event
    @schedule = schedule
    @number_of_people = number_of_people
    mail(to: @farmer.email, subject: "【重要】農業体験のリマインドのご連絡")
  end
end
