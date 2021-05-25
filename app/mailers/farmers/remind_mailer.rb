class Farmers::RemindMailer < ApplicationMailer
  def remind_event_schedule
    @url = "http://vegecircle.com/Farmers/sign_in"

    tomorrow_schedules = Schedule.all.select do |schedule|
      schedule.date - Date.current == 1
    end
    tomorrow_schedules_ids = tomorrow_schedules.pluck(:id)
    ids_of_farmers_have_tomorrow_event = Schedule.where(id: tomorrow_schedules_ids).pluck(:event_id)
    farmers_have_tomorrow_schedule_ids = Event.where(id: ids_of_farmers_have_tomorrow_event).pluck(:farmer_id)
    farmers_have_tomorrow_schedule = Farmer.where(id: farmers_have_tomorrow_schedule_ids)

    farmers_have_tomorrow_schedule.each do |farmer|
      @farmer = farmer
      @event = Event.find_by(id: ids_of_farmers_have_tomorrow_event, farmer_id: farmer.id)
      @schedule = Schedule.find_by(date: (Date.current + 1 ), event_id: @event.id)
      @number_of_people = Reservation.where(schedule_id: @schedule.id).pluck(:people).sum
      mail(to: farmer.email, subject: "【重要】農業体験のリマインドのご連絡")
    end
  end
end
