class Schedule < ApplicationRecord

  belongs_to :event
  has_many :reservations, dependent: :destroy

  with_options presence: true do
    validates :date
    validates :start_time
    validates :end_time
  end

  def date_update(start_time, end_time)
    update(start_time: DateTime.new(self.date.year, self.date.month, self.date.day, start_time.split(":")[0].to_i, start_time.split(":")[1].to_i, 00, "+09:00"),
           end_time: DateTime.new(self.date.year, self.date.month, self.date.day, end_time.split(":")[0].to_i, end_time.split(":")[1].to_i, 00, "+09:00"))
  end

  def eventdate_update(event)
    min_schedule_date = Schedule.where(event_id: event.id).pluck(:date).min
    max_schedule_date = Schedule.where(event_id: event.id).pluck(:date).max
    if (min_schedule_date != event.start_date) || (max_schedule_date != event.end_date)
      event.update(start_date: min_schedule_date, end_date: max_schedule_date)
    end
  end

  def self.end_events_of_the_day
    Schedule.where(date: (Date.current - 1)).update(is_deleted: true)
  end

end
