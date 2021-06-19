class Schedule < ApplicationRecord
  belongs_to :event
  has_many :reservations, dependent: :destroy

  with_options presence: true do
    validates :date
    validates :start_time
    validates :end_time
    validates :people, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  end

  validate do
    errors.add(:date, 'は本日以降の日付を選択してください') if (data.exists? && date < Date.current)
    if start_time.exists? && end_time.exists?
      errors.add(:end_time, 'は開始時刻よりも後の時刻を選択してください') if (start_time >= end_time)
    end
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

  def notice_created_by(farmer)
    recipients = Reservation.select(:customer_id).where(schedule_id: self.id)
    if recipients.exists?
      notice = Notice.new(farmer_id: farmer.id, event_id: self.event_id, action: "農業体験のスケジュール更新")
      recipients.each do |recipient|
        notice.customer_id = recipient.customer_id
        reservation = Reservation.find_by(schedule_id: self.id, customer_id: recipient.customer_id)
        notice.reservation_id = reservation.id
        notice.save
      end
    end
  end

  def self.end_events_of_the_day
    where(date: (Date.current - 1)).update(is_deleted: true)
  end
end
