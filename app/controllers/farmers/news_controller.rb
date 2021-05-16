class Farmers::NewsController < ApplicationController
  before_action :authenticate_farmer!

  def create
    @news = current_farmer.news.new(news_params)
    unless @news.save
      @farmer = current_farmer
      render template: "farmers/farmers/show"
    end
  end

  def destroy
    news = News.find(params[:id])
    news.destroy
  end

  private

  def news_params
    params.require(:news).permit(:news, :news_image)
  end
end
