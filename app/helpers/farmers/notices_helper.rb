module Farmers::NoticesHelper

  def show_content_of(notice)
    @customer = notice.customer
    unless notice.event_id.blank?
      @event = notice.event
    end

    case notice.action
    when "フォロー" then
      "#{@customer.nickname}さんがあなたをフォローしました"
    when "チャット" then
      @chat_link = link_to @event.title, farmers_event_path(@event, anchor: "chat"), class: "text-primary font-weight-bold"
      @chat_link + "のチャット欄に投稿がありました"
    when "予約" then
      @reservation = notice.reservation
      @schedule = Schedule.find(@reservation.schedule_id)
      @schedule_link = link_to @event.title, farmers_event_schedule_path(@event, @schedule), class: "text-primary font-weight-bold"
      @schedule_link + "（#{@schedule.date.strftime("%m月%d日")}）に、#{@customer.nickname}さんより#{@reservation.people}人の予約がありました"
    end
  end
end
