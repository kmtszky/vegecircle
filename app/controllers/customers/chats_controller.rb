class Customers::ChatsController < ApplicationController
  before_action :authenticate_customer!

  def create
    @chat = current_custmer.chats.new(chat_params)
    if @chat.save
      redirect_to request.referer
    else
      @farmer = Farmer.find(params[:id])
      news_index = News.where(farmer_id: params[:id]).order('created_at DESC')
      @news_last3 = news_index.first(3)
      @news_left = news_index.offset(3)
      @recipes = Recipe.where(farmer_id: params[:id]).order('created_at DESC').first(5)
      @events = Event.where(farmer_id: params[:id]).order('created_at DESC').first(5)
      chat_index = Chat.where(farmer_id: params[:id]).order('created_at DESC')
      @chat_last5 = chat_index.first(5)
      @chat_left = chat_index.offset(5)
      render farmer_path
    end
  end

  def destroy
    chat = Chat.find(params[:id])
    chat.destroy
    redirect_to request.referer
  end

  private

  def chat_params
    params.require(:chat).permit(:chat, :chat_image)
  end
end
