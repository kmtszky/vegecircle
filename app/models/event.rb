class Event < ApplicationRecord
  belongs_to :farmer
  has_many :chats, dependent: :destroy
  has_many :event_favorites, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :notices, dependent: :destroy
  attr_accessor :start_time
  attr_accessor :end_time
  attr_accessor :number_of_participants
  attachment :plan_image

  with_options presence: true do
    validates :title
    validates :plan_image
    validates :body
    validates :fee, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :cancel_change
    validates :location
    validates :access
    validates :start_date
    validates :end_date
    validates :start_time, on: :create
    validates :end_time, on: :create
    validates :number_of_participants, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, on: :create
  end

  validate do
      errors.add(:start_date, 'は本日以降の日付を選択してください') if (start_date.present? && start_date < Date.current)
      errors.add(:end_date,   'は本日以降の日付を選択してください') if (end_date.present? && end_date < Date.current)
    if start_date.present? && end_date.present?
      errors.add(:end_date, 'は開始日以降の日付を選択してください') if (end_date < start_date)
    end
    if start_time.present? && end_time.present?
      errors.add(:end_time, 'は開始時刻よりも後の時刻を選択してください') if (start_time >= end_time)
    end
  end

  geocoded_by :location
  after_validation :geocode

  enum parking: {
    "駐車場あり、予約不要": 0,
    "駐車場あり、予約要": 1,
    "駐車場なし": 2,
  }

  def build_start_or_end_time(start_or_end, date)
    DateTime.new(date.year, date.month, date.day, start_or_end.split(":")[0].to_i, start_or_end.split(":")[1].to_i, 00, "+09:00")
  end

  def create_schedules(farmer)
    start_date.step(start_date + number_of_days, 1) do |date|
      create_schedule(date) unless farmer.has_schedules_on_the_day?(date)
    end
  end

  def date_update
    update(start_date: min_schedule_date, end_date: max_schedule_date) if schedule_date_not_equal_start_or_end_date?
  end

  def favorited_by?(customer)
    event_favorites.where(customer_id: customer.id).exists?
  end

  def has_schedules?
    schedules.exists?
  end

  def notice_create
    reserved_schedule_ids = schedules.select(:id)
    customers = Reservation.select(:customer_id).where(schedule_id: reserved_schedule_ids)
    notice_send_to(customers) if customers.present?
  end

  def self.search_for(content, method)
    case method
    when 'forward'
      where('location like ?', content + '%')
    when 'date'
      where('start_date <= ?', content).where('end_date >= ?', content)
    else
      where('title like ?', '%' + content + '%').or(Event.where('location like ?', '%' + content + '%'))
    end
  end

  def self.sorts(method)
    case method
    when 'asc'
      order(:start_date)
    when 'desc'
      order('start_date DESC')
    when 'like'
      includes(:event_favorites).sort {|a, b| b.event_favorites.size <=> a.event_favorites.size }
    else
      order('created_at DESC')
    end
  end

  private

  def create_schedule(date)
    Schedule.create(date: date,
                    event_id: id,
                    people: number_of_participants,
                    start_time: build_start_or_end_time(start_time, date),
                    end_time: build_start_or_end_time(end_time, date))
  end

  def max_schedule_date
    schedules.pluck(:date).max
  end

  def min_schedule_date
    schedules.pluck(:date).min
  end

  def max_schedule_date_not_equal_end_date?
    max_schedule_date != end_date
  end

  def min_schedule_date_not_equal_start_date?
    min_schedule_date != start_date
  end

  def number_of_days
    end_date - start_date
  end

  def schedule_date_not_equal_start_or_end_date?
    min_schedule_date_not_equal_start_date? || max_schedule_date_not_equal_end_date?
  end

  def notice_send_to(customers)
    notice = Notice.new(event_id: id, action: "農業体験の内容更新")
    customers.each do |customer|
      notice.customer_id = customer.customer_id
      notice.save
    end
  end
end
