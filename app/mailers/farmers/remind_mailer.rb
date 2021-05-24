class Farmers::RemindMailer < ApplicationMailer
  def remind_event_schedule
    @url = "http://vegecircle.com/Farmers/sign_in"

    tomorrow_schedules = Schedule.all.select do |schedule|
      schedule.date - Date.current == 1
    end
    tomorrow_schedule_ids = tomorrow_schedules.pluck(:id)
    ids_of_farmers_have_tomorrow_schedule = Schedule.where(id: tomorrow_schedule_ids).pluck(:farmer_id)
    farmers_have_tomorrow_schedule = Farmer.where(id: ids_of_farmers_have_tomorrow_schedule)

    farmers_have_tomorrow_schedule.each do |farmer|
      @farmer = farmer
      @schedule = @farmer.events.schedules.where(date: (Date.current + 1 ))
      @event = Event.find_by(id: @schedule.event_id)
      mail(to: farmer.email, subject: "【重要】農業体験のリマインドのご連絡")
    end
  end
end
