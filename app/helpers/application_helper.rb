module ApplicationHelper
  def converting_to_jpy(price)
    "#{price.to_s(:delimited, delimiter: ',')}円"
  end

  def create_time(time)
    time.strftime("%Y/%m/%d %H:%M")
  end

  def unchecked_notices_count(user)
    if user == current_customer
      notices = user.notices.where(checked: false, action: ["チャット", "農業体験の内容更新", "農業体験のスケジュール更新", "お知らせ"]).size
      @notices = notices if notices > 0
    else
      notices = user.notices.where(checked: false, action: ["フォロー", "チャット", "予約"]).size
      @notices = notices if notices > 0
    end
  end

  def show_date(date)
    date.strftime("%Y/%m/%d")
  end

  def show_time(time)
    time.strftime("%H:%M")
  end
end
