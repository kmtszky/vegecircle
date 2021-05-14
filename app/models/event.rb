class Event < ApplicationRecord

  belongs_to :farmer
  has_many :favorites, dependent: :destroy
  has_many :reservations, dependent: :destroy
  attr_accessor :start_date
  attr_accessor :end_date
  attachment :plan_image

  with_options presence: true do
    validates :title
    validates :plan_image_id
    validates :body
    validates :fee, numericality: { only_integer: true }
    validates :cancel_change
    validates :date
    validates :start_time
    validates :end_time
    validates :location
    validates :access
    validates :start_date
    validates :end_date
  end

  validate do
    require "date"
    unless date == nil
      errors.add(:date, 'は本日以降の日付を選択してください') if (date < Date.today)
    end
  end

  validate do
    require "date"
    unless (start_date == nil) && (end_date == nil)
      errors.add(:start_date, 'は本日以降の日付を選択してください') if (start_date < Date.today)
      errors.add(:end_date,   'は本日以降の日付を選択してください') if (end_date < Date.today)
    end
  end

  def favorited_by?(customer)
    event_favorites.where(customer_id: customer.id).exists?
  end
end
