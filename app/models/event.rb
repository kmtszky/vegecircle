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
    validates :fee, numericality: { only_integer: true }
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

  def create_schedules(farmer)
    number_of_days = self.end_date - self.start_date
    self.start_date.step(self.start_date + number_of_days, 1) do |date|
      schedule = Schedule.new(date: date, event_id: self.id, people: self.number_of_participants)
      schedule.start_time = DateTime.new(date.year, date.month, date.day, self.start_time.split(":")[0].to_i, self.start_time.split(":")[1].to_i, 00, "+09:00")
      schedule.end_time = DateTime.new(date.year, date.month, date.day, self.end_time.split(":")[0].to_i, self.end_time.split(":")[1].to_i, 00, "+09:00")
      schedule.save unless farmer.has_schedules_on_the_day?(date)
    end
  end

  def date_update
    min_schedule_date = Schedule.where(event_id: self.id).pluck(:date).min
    max_schedule_date = Schedule.where(event_id: self.id).pluck(:date).max
    if (min_schedule_date != self.start_date) || (max_schedule_date != self.end_date)
      self.update(start_date: min_schedule_date, end_date: max_schedule_date)
    end
  end

  def favorited_by?(customer)
    event_favorites.where(customer_id: customer.id).exists?
  end

  def has_schedules?
    schedules.where(event_id: self.id).exists?
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
end
