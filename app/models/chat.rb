class Chat < ApplicationRecord
  belongs_to :customer, optional: true
  belongs_to :event
  belongs_to :farmer, optional: true

  validates :chat, presence: true

  def notice_created_by(farmer)
    chat_participants_ids = Chat.where(event_id: self.event_id).pluck(:customer_id)
    schedules_ids = Schedule.select(:id).where(event_id: self.event_id)
    event_participants_ids = Reservation.where(schedule_id: schedules_ids).pluck(:customer_id)
    customer_ids = (chat_participants_ids | event_participants_ids).compact!
    recipients = Customer.where(id: customer_ids)
    if recipients.present?
      notice = Notice.new(farmer_id: farmer.id, event_id: self.event_id, action: "チャット")
      recipients.each do |recipient|
        notice.customer_id = recipient.id
        notice.save
      end
    end
  end

  def notice_created_by_customer(customer, event_id)
    event = Event.find(event_id)
    Notice.create(customer_id: customer.id, farmer_id: event.farmer_id, event_id: event_id, action: "チャット")
  end
end
