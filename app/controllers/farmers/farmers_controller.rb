class Farmers::FarmersController < ApplicationController
  before_action :authenticate_farmer!
  before_action :set_farmer, except: [:index]

  def index
    @farmers = Farmer.where(is_deleted: false).page(params[:page]).reverse_order

    @northern = [ "北海道", "青森県", "岩手県", "宮城県", "秋田県", "山形県", "福島県" ]
    @kanto = [ "茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "東京都", "神奈川県" ]
    @middle = [ "新潟県", "富山県", "石川県", "福井県", "山梨県", "長野県", "岐阜県", "静岡県", "愛知県", "三重県" ]
    @kansai = [ "滋賀県", "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県" ]
    @western = [ "鳥取県", "島根県", "岡山県", "広島県", "山口県", "徳島県", "香川県", "愛媛県", "高知県" ]
    @southern = [ "福岡県", "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県", "鹿児島県", "沖縄県" ]
  end

  def show
    if current_farmer == @farmer
      @news = News.new
      @chat = Chat.new
    end
    @news = News.new
    news_index = News.where(farmer_id: @farmer.id).order('created_at DESC')
    @news_last3 = news_index.first(3)
    @news_left = news_index.offset(3)
    @recipes = Recipe.where(farmer_id: @farmer.id).order('created_at DESC').first(5)
    @events = Event.where(farmer_id: @farmer.id).order('created_at DESC').first(5)
    chat_index = Chat.where(farmer_id: @farmer.id).order('created_at DESC')
    @chat_last5 = chat_index.first(5)
    @chat_left = chat_index.offset(5)
    @evaluations = Evaluation.where(farmer_id: @farmer.id).order('created_at DESC').first(3)
  end

  def edit
    unless current_farmer == @farmer
      redirect_to farmers_farmer_path(current_farmer), flash: {danger: "他の農家さんのプロフィールの変更は出来ません"}
    end
  end

  def update
    if @farmer.update(farmer_params)
      redirect_to farmers_farmer_path(current_farmer), flash: {success: "登録情報を更新しました"}
    else
      render :edit
    end
  end

  def unsubscribe
  end

  def withdraw
    @farmer.update(is_deleted: true)
    @farmer.events.where("start_date > ?", Date.current).destroy_all
    redirect_to root_path, flash: {success: "ご利用いただき大変ありがとうございました！またのご利用を心よりお待ちしております。"}
  end

  private

  def set_farmer
    @farmer = Farmer.find(params[:id])
  end

  def farmer_params
    params.require(:farmer).permit(:name, :phone, :farm_address, :store_address, :introduction, :farmer_image, :image_1, :image_2, :image_3)
  end
end
