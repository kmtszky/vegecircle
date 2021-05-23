class Customers::ThanxMailer < ApplicationMailer

  def complete_reservation(reservation)
    @reservation = reservation
    @schedule = Schedule.find_by(id: @reservation.schedule_id)
    @event = Event.find_by(id: @schedule.event_id)
    @customer = Customer.find_by(id: @reservation.customer_id)
    mail(to: @customer.email, subject: "【重要】農業体験ご予約完了のお知らせ" )
  end
end
