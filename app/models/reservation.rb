class Reservation < ApplicationRecord
  belongs_to :customer
  belongs_to :schedule
  has_one :notice

  validates :people, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  def notice_created_by(customer, event)
    Notice.create(farmer_id: event.farmer_id, customer_id: customer.id, event_id: event.id, reservation_id: self.id, action: "予約")
  end
end
