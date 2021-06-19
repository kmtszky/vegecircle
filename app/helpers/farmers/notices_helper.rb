module Farmers::NoticesHelper

  def show_content_of(notice)
    @customer = notice.customer
    @event = notice.event if notice.event_id.exists?
    event_link = link_to @event.title, farmers_event_path(@event), class: "text-primary text-bold"

    case notice.action
    when "フォロー" then
      "#{@customer.nickname}さんがあなたをフォローしました"
    when "チャット" then
      "#{event_link}のチャット欄に投稿がありました"
    when "予約" then
      @reservation = notice.reservation
      @schedule = Schedule.find(@reservation.schedule_id)
      "#{@schedule.date.strftime("%m月%d日")}の#{event_link}に、#{@customer.nickname}さんより#{@reservation.people}人の予約がありました"
    end
  end
end
