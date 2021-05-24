class Customers::RemindMailer < ApplicationMailer
  def remind_reservation
    @url = "http://vegecircle.com/customers/sign_in"

    tomorrow_schedules = Schedule.all.select do |schedule|
      schedule.date - Date.current == 1
    end
    tomorrow_schedules_ids = tomorrow_schedules.pluck(:id)
    ids_of_customers_have_tomorrow_reservation = Reservation.where(schedule_id: tomorrow_schedules_ids).pluck(:customer_id)
    customers_have_tomorrow_reservation = Customer.where(id: ids_of_customers_have_tomorrow_reservation)

    customers_have_tomorrow_reservation.each do |customer|
      @customer = customer
      @reservation = Reservation.where(schedule_id: tomorrow_schedules_ids).find_by(customer_id: customer.id)
      @schedule = Schedule.find(@reservation.schedule_id)
      @event = Event.find(@schedule.event_id)
      mail(to: customer.email, subject: "【重要】農業体験のリマインドのご連絡")
    end
  end
end
