class ReservRemindMailJob < ApplicationJob
  queue_as :email

  def perform
    tomorrow_schedules = Schedule.all.select do |sch|
      sch.date - Date.current == 1
    end
    tomorrow_schedules_ids = tomorrow_schedules.pluck(:id)
    ids_of_customers_have_tomorrow_reservation = Reservation.where(schedule_id: tomorrow_schedules_ids).pluck(:customer_id)
    customers_have_tomorrow_reservation = Customer.where(id: ids_of_customers_have_tomorrow_reservation)

    customers_have_tomorrow_reservation.each do |customer|
      reservation = Reservation.where(schedule_id: tomorrow_schedules_ids).find_by(customer_id: customer.id)
      schedule = Schedule.find(reservation.schedule_id)
      event = Event.find(schedule.event_id)
      Customers::RemindMailer.remind_reservation(customer, reservation, schedule, event).deliver_now
    end
  end
end
