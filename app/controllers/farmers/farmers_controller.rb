class Farmers::FarmersController < ApplicationController
  before_action :authenticate_farmer!, exept: [:show]
  before_action :set_farmer

  def show
    @farmer = Farmer.find(params[:id])
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
  end

  def edit
  end

  def update
    if @farmer.update(farmer_params)
      redirect_to farmer_path(current_farmer), flash: {success: "登録情報を更新しました"}
    else
      render :edit
    end
  end

  def unsubscribe
  end

  def withdraw
    @farmer.update(is_deleted: true)
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
