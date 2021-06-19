class Reservation < ApplicationRecord
  belongs_to :customer
  belongs_to :schedule

  validates :people, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  def create_notice(event)
    notice = Notice.new(farmer_id: event.farmer_id, event_id: event_id, action: "予約")
    notice.save
  end
end
