class Farmers::FarmersController < ApplicationController
  before_action :authenticate_farmer!, exept: [:show]
  before_action :set_farmer

  def show
    if current_farmer == @farmer
      @news = News.new
    end
    news_index = News.where(farmer_id: @farmer.id).order('created_at DESC')
    @news_last3 = news_index.first(3)
    @news_left = news_index.offset(3)
    recipe_index = Recipe.where(farmer_id: @farmer.id).order('created_at DESC')
    @recipes = recipe_index.first(5)
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
