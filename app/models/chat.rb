class Chat < ApplicationRecord
  belongs_to :customer, optional: true
  belongs_to :event
  belongs_to :farmer, optional: true

  validates :chat, presence: true

  def notifice_created_by(farmer)
    notifice = Notice.new(event_id: self.event_id, action: "チャット")
    chat_participants_ids = Chat.select(:customer_id).where(event_id: self.event_id)
    schedules_ids = Schedule.select(:id).where(event_id: self.event_id)
    event_participants_ids = Reservation.select(:customer_id).where(schedule_id: schedules_ids)
    recipients = Customer.where(id: (chat_participants_ids + event_participants_ids).distinct)
    if recipients.present?
      recipients.each do |recipient|
        notifice.customer_id = recipient.customer_id
      end
      notifice.save
    end
  end

  def notifice_created_by_custmomer(event_id)
    event = Event.find_by(id: event_id)
    notifice = Notice.new(farmer_id: event.farmer_id, event_id: event_id, action: "チャット")
    notifice.save
  end
end
