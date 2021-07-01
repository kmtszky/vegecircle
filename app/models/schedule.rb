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
    errors.add(:date, 'は本日以降の日付を選択してください') if (date.present? && date < Date.current)
    if start_time.present? && end_time.present?
      errors.add(:end_time, 'は開始時刻よりも後の時刻を選択してください') if (start_time >= end_time)
    end
  end

  def date_update(start_time, end_time)
    update(start_time: event.build_start_or_end_time(start_time, date),
           end_time: event.build_start_or_end_time(end_time, date))
  end

  def eventdate_update
    event.date_update
  end

  def notice_created_by(farmer)
    recipients = Reservation.select(:customer_id).where(schedule_id: id)
    if recipients.present?
      notice = Notice.new(farmer_id: farmer.id, event_id: event_id, action: "農業体験のスケジュール更新")
      recipients.each do |recipient|
        notice.customer_id = recipient.customer_id
        reservation = Reservation.find_by(schedule_id: id, customer_id: recipient.customer_id)
        notice.reservation_id = reservation.id
        notice.save
      end
    end
  end

  def self.end_events_of_the_day
    where(date: (Date.current - 1)).update(is_deleted: true)
  end
end
