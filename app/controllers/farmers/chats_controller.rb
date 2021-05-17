class Farmers::ChatsController < ApplicationController
  before_action :authenticate_farmer!

  def create
    @chat = current_farmer.chats.new(chat_params)
    if @chat.save
      redirect_to farmers_farmer_path(current_farmer)
    else
      @farmer = current_farmer
      @news = News.new
      news_index = News.where(farmer_id: @farmer.id).order('created_at DESC')
      @news_last3 = news_index.first(3)
      @news_left = news_index.offset(3)
      @recipes = Recipe.where(farmer_id: @farmer.id).order('created_at DESC').first(5)
      @events = Event.where(farmer_id: @farmer.id).order('created_at DESC').first(5)
      chat_index = Chat.where(farmer_id: @farmer.id).order('created_at DESC')
      @chat_last5 = chat_index.first(5)
      @chat_left = chat_index.offset(5)
      render template: "farmers/farmers/show"
    end
  end

  def destroy
    chat = Chat.find(params[:id])
    if chat.farmer_id == current_farmer.id
      chat.destroy
      redirect_to farmers_farmer_path(current_farmer)
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:chat, :chat_image)
  end
end
