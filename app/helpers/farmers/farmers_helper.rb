module Farmers::FarmersHelper
  def participants(reservations, schedule)
    reservations.where(schedule_id: schedule.id).pluck(:people).sum
  end
end
