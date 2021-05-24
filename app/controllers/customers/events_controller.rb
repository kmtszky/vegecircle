class Customers::EventsController < ApplicationController
  def index
    @events = Event.where('end_date >= ?', Date.current).order(:start_date).page(params[:page]).reverse_order

    @northern = [ "北海道", "青森県", "岩手県", "宮城県", "秋田県", "山形県", "福島県" ]
    @kanto = [ "茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "東京都", "神奈川県" ]
    @middle = [ "新潟県", "富山県", "石川県", "福井県", "山梨県", "長野県", "岐阜県", "静岡県", "愛知県", "三重県" ]
    @kansai = [ "滋賀県", "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県" ]
    @western = [ "鳥取県", "島根県", "岡山県", "広島県", "山口県", "徳島県", "香川県", "愛媛県", "高知県" ]
    @southern = [ "福岡県", "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県", "鹿児島県", "沖縄県" ]
  end

  def show
    @event = Event.find(params[:id])
    @schedules = @event.schedules.where(is_deleted: false, is_full: false)
    @schedule = @schedules.first
    @chat = Chat.new
    @chats = Chat.where(event_id: params[:id])
  end
end
