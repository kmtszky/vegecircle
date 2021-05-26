class Schedule < ApplicationRecord

  belongs_to :event
  has_many :reservations, dependent: :destroy

  with_options presence: true do
    validates :date, uniqueness: true
    validates :start_time
    validates :end_time
  end

  def self.end_events_of_the_day
    Schedule.where(date: (Date.current - 1)).update(is_deleted: true)
  end
end
