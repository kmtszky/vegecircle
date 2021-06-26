class Farmers::FarmersController < ApplicationController
  before_action :authenticate_farmer!
  before_action :set_farmer, only: [:edit, :update, :withdraw]

  def show
    @news = News.new
    @chat = Chat.new
    news_index = News.where(farmer_id: current_farmer.id).order('created_at DESC')
    @news_last3 = news_index.first(3)
    @news_left = news_index.offset(3)
    @recipes = Recipe.where(farmer_id: current_farmer.id).order('created_at DESC').first(3)
    @events = Event.where(["farmer_id = ? and end_date >= ?", current_farmer.id, Date.current]).order('start_date ASC').first(3)
    @evaluations = Evaluation.where(farmer_id: current_farmer.id).order('created_at DESC').first(3)

    if current_farmer.evaluations.exists?
      @average_rating = current_farmer.evaluations.average(:evaluation).round(2)
    else
      @average_rating = 0
    end
  end

  def edit
  end

  def update
    if @farmer.update(farmer_params)
      redirect_to farmers_farmers_path, flash: { success: "登録情報を更新しました" }
    else
      render :edit
    end
  end

  def unsubscribe
  end

  def withdraw
    @farmer.update(is_deleted: true)
    current_farmer.events.where("start_date > ?", Date.current).destroy_all
    redirect_to root_path, flash: { success: "ご利用いただき大変ありがとうございました！またのご利用を心よりお待ちしております" }
  end

  def evaluations
    @evaluations = current_farmer.evaluations
  end

  def calender
    @schedules = current_farmer.schedules.where(event_id: current_farmer.events.ids)
    @reservations = current_farmer.reservations
  end

  private

  def set_farmer
    @farmer = Farmer.find(current_farmer.id)
  end

  def farmer_params
    params.require(:farmer).permit(:name, :phone, :farm_address, :store_address, :introduction, :farmer_image, :image_1, :image_2, :image_3)
  end
end
