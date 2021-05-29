class Customers::RemindMailer < ApplicationMailer
  def remind_reservation(customer, reservation, schedule, event)
    @url = "http://vegecircle.com/customers/sign_in"
    @customer = customer
    @reservation = reservation
    @schedule = schedule
    @event = event
    mail(to: @customer.email, subject: "【重要】農業体験のリマインドのご連絡")
  end
end