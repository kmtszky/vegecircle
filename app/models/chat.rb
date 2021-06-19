class Chat < ApplicationRecord
  belongs_to :customer, optional: true
  belongs_to :event
  belongs_to :farmer, optional: true

  validates :chat, presence: true

  def notice_created_by(farmer)
    notice = Notice.new(event_id: self.event_id, action: "チャット")
    chat_participants_ids = Chat.select(:customer_id).where(event_id: self.event_id)
    schedules_ids = Schedule.select(:id).where(event_id: self.event_id)
    event_participants_ids = Reservation.select(:customer_id).where(schedule_id: schedules_ids)
    recipients = Customer.where(id: (chat_participants_ids + event_participants_ids).distinct)
    if recipients.present?
      recipients.each do |recipient|
        notice.customer_id = recipient.customer_id
      end
      notice.save
    end
  end

  def create_notice(event_id)
    event = Event.find_by(id: event_id)
    notice = Notice.new(farmer_id: event.farmer_id, event_id: event_id, action: "チャット")
    notice.save
  end
end
