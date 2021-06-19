class Chat < ApplicationRecord
  belongs_to :customer, optional: true
  belongs_to :event
  belongs_to :farmer, optional: true

  validates :chat, presence: true

  def notice_created_by(farmer)
    chat_participants_ids = Chat.select(:customer_id).where(event_id: self.event_id)
    schedules_ids = Schedule.select(:id).where(event_id: self.event_id)
    event_participants_ids = Reservation.select(:customer_id).where(schedule_id: schedules_ids)
    recipients = Customer.where(id: (chat_participants_ids + event_participants_ids).distinct)
    if recipients.present?
      notice = Notice.new(farmer_id: farmer.id, event_id: self.event_id, action: "チャット")
      recipients.each do |recipient|
        notice.customer_id = recipient.customer_id
        notice.save
      end
    end
  end

  def notice_created_by_customer(customer, event_id)
    event = Event.find(event_id)
    Notice.create(customer_id: customer.id, farmer_id: event.farmer_id, event_id: event_id, action: "チャット")
  end
end
