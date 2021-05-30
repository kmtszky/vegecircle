class Schedule < ApplicationRecord

  belongs_to :event
  has_many :reservations, dependent: :destroy

  with_options presence: true do
    validates :date
    validates :start_time
    validates :end_time
  end

  def date_update(start_time, end_time, date)
    update(start_time: DateTime.new(self.date.year, self.date.month, self.date.day, start_time.split(":")[0].to_i, start_time.split(":")[1].to_i, 00, "+09:00"),
           end_time: DateTime.new(self.date.year, self.date.month, self.date.day, end_time.split(":")[0].to_i, end_time.split(":")[1].to_i, 00, "+09:00"))
  end

  def self.end_events_of_the_day
    Schedule.where(date: (Date.current - 1)).update(is_deleted: true)
  end

  def self.deliver_mail
    tomorrow_schedules = Schedule.all.select do |schedule|
      schedule.date - Date.current == 1
    end
    tomorrow_schedules_ids = tomorrow_schedules.pluck(:id)
    ids_of_farmers_have_tomorrow_event = Schedule.where(id: tomorrow_schedules_ids).pluck(:event_id)
    farmers_have_tomorrow_schedule_ids = Event.where(id: ids_of_farmers_have_tomorrow_event).pluck(:farmer_id)
    farmers_have_tomorrow_schedule = Farmer.where(id: farmers_have_tomorrow_schedule_ids)

    farmers_have_tomorrow_schedule.each do |farmer|
      event = Event.find_by(id: ids_of_farmers_have_tomorrow_event, farmer_id: farmer.id)
      schedule = Schedule.find_by(date: (Date.current + 1 ), event_id: event.id)
      number_of_people = Reservation.where(schedule_id: schedule.id).pluck(:people).sum
      Farmers::RemindMailer.remind_event_schedule(farmer, event, schedule, number_of_people).deliver_now
    end
  end
end
