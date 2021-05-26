class Event < ApplicationRecord

  belongs_to :farmer
  has_many :event_favorites, dependent: :destroy
  has_many :schedules, dependent: :destroy
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
    validates :number_of_participants, numericality: { only_integer: true }, on: :create
  end

  validate do
    unless start_time.blank? && end_time.blank?
      errors.add(:start_date, 'は本日以降の日付を選択してください') if (start_date < Date.current)
      errors.add(:end_date,   'は本日以降の日付を選択してください') if (end_date < Date.current)
      errors.add(:end_date,   'は開始日以降の日付を選択してください') if (end_date < start_date)
    end
  end

  validate do
    unless start_time.blank? && end_time.blank?
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

  def favorited_by?(customer)
    event_favorites.where(customer_id: customer.id).exists?
  end

  def self.search_for(content, method)
    if method == 'forward'
      Event.where('end_date >= ?', Date.current).where('location like ?', content + '%')
    else
      Event.where('end_date >= ?', Date.current).or(Event.where('title like ?', '%' + content + '%')).or(Event.where('location like ?', '%' + content + '%'))
    end
  end

  def self.search_for_date(event_date, method)
    Event.where('end_date >= ?', Date.current).where('start_date <= ?', event_date).where('end_date >= ?', event_date)
  end

  def self.search_for_all(content, method)
    Event.where('title like ?', '%' + content + '%').or(Event.where('location like ?', '%' + content + '%'))
  end

  def has_schedules?
    schedules.where(event_id: self.id).exists?
  end
end
