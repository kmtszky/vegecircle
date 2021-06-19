module Customers::NoticesHelper

  def show_content_of(notice)
    @farmer = notice.farmer
    farmer_link = link_to @farmer.name, farmer_path(@farmer), class: "text-primary text-bold"
    if notice.event_id.exists?
      @event = notice.event
      event_link = link_to @event.title, farmers_event_path(@event), class: "text-primary text-bold"
    end

    case notice.action
    when "チャット" then
      "#{farmer_link}さんが#{event_link}のチャット欄を更新しました"
    when "農業体験の内容更新" then
      "#{farmer_link}さんが#{event_link}の内容を更新しました"
    when "農業体験のスケジュール更新" then
      reservation = notice.reservation
      @schedule = Schedule.find(reservation.schedule_id)
      schedule_link = link_to @event.title, event_schedule_path(@event, @schedule), "text-primary text-bold"
      "#{@schedule.date.strftime("%m月%d日")}の#{schedule_link}のスケジュールまたは最大参加可能人数が更新されました"
    when "お知らせ" then
      "#{farmer_link}さんがお知らせを更新しました"
    end
  end
end