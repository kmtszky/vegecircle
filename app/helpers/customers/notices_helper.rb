module Customers::NoticesHelper

  def show_content_of_customers(notice)
    @farmer = notice.farmer
    @farmer_link = link_to @farmer.name, farmer_path(@farmer), class: "text-primary font-weight-bold"
    unless notice.event_id.blank?
      @event = notice.event
      @event_link = link_to @event.title, event_path(@event), class: "text-primary font-weight-bold"
    end

    case notice.action
    when "チャット" then
      @chat_link = link_to @event.title, event_path(@event, anchor: "chat"), class: "text-primary font-weight-bold"
      @farmer_link + "さんが" + @chat_link + "のチャット欄を更新しました"
    when "農業体験の内容更新" then
      @farmer_link + "さんが" + @event_link + "の内容を更新しました"
    when "農業体験のスケジュール更新" then
      reservation = notice.reservation
      @schedule = Schedule.find(reservation.schedule_id)
      @schedule_link = link_to @event.title, event_schedule_path(@event, @schedule), class: "text-primary font-weight-bold"
      @schedule_link + "（#{@schedule.date.strftime("%m月%d日")}）のスケジュール、または予約可能人数が更新されました"
    when "お知らせ" then
      @farmer_link + "さんがお知らせを更新しました"
    end
  end
end