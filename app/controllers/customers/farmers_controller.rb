class Customers::FarmersController < ApplicationController
  def index
    @farmers = Farmer.where(is_deleted: false).page(params[:page]).reverse_order
  end

  def show
    @farmer = Farmer.find(params[:id])
    news_index = News.where(farmer_id: params[:id]).order('created_at DESC')
    @news_last3 = news_index.first(3)
    @news_left = news_index.offset(3)
    @recipes = Recipe.where(farmer_id: params[:id]).order('created_at DESC').first(5)
    @events = Event.where(farmer_id: params[:id]).order('created_at DESC').first(5)
  end
end
