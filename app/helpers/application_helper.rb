module ApplicationHelper

  def area_search
    @northern = [ "北海道", "青森県", "岩手県", "宮城県", "秋田県", "山形県", "福島県" ]
    @kanto = [ "茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "東京都", "神奈川県" ]
    @middle = [ "新潟県", "富山県", "石川県", "福井県", "山梨県", "長野県", "岐阜県", "静岡県", "愛知県", "三重県" ]
    @kansai = [ "滋賀県", "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県" ]
    @western = [ "鳥取県", "島根県", "岡山県", "広島県", "山口県", "徳島県", "香川県", "愛媛県", "高知県" ]
    @southern = [ "福岡県", "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県", "鹿児島県", "沖縄県" ]
    
    
  end

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
