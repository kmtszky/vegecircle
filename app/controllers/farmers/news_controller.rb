class Farmers::NewsController < ApplicationController
  before_action :authenticate_farmer!
  skip_before_action :set_prefectures

  def create
    @news = current_farmer.news.new(news_params)
    if @news.save
      @news.notice_created_by(current_farmer)
      redirect_to farmers_farmers_path, flash: { success: "お知らせを投稿しました" }
    else
      @farmer = current_farmer
      news_index = News.where(farmer_id: @farmer.id).order('created_at DESC')
      @news_last3 = news_index.first(3)
      @news_left = news_index.offset(3)
      @recipes = Recipe.where(farmer_id: @farmer.id).order('created_at DESC').first(5)
      @events = Event.where(farmer_id: @farmer.id).order('created_at DESC').first(5)
      @evaluations = Evaluation.where(farmer_id: params[:id]).order('created_at DESC').first(3)
      render template: "farmers/farmers/show"
    end
  end

  def destroy
    news = News.find(params[:id])
    news.destroy
    news_index = News.where(farmer_id: current_farmer.id).order('created_at DESC')
    @news_last3 = news_index.first(3)
    @news_left = news_index.offset(3)
  end

  private

  def news_params
    params.require(:news).permit(:news, :news_image)
  end
end
