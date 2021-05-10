class Farmers::NewsController < ApplicationController
  before_action :authenticate_farmer!

  def create
    @news = current_farmer.news.new(news_params)
    if @news.save
      redirect_to farmer_path(current_farmer)
    else
      @farmer = current_farmer
      render template: "farmers/farmers/show"
    end
  end

  def destroy
    news = News.find(params[:id])
    if news.destroy
      redirect_to farmer_path(current_farmer)
    else
      render template: "farmers/farmers/show"
    end
  end

  private

  def news_params
    params.require(:news).permit(:news, :news_image)
  end
end
