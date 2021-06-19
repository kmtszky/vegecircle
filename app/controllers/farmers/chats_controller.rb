class Farmers::ChatsController < ApplicationController
  before_action :authenticate_farmer!
  before_action :set_farmer

  def create
    @chat = current_farmer.chats.new(chat_params)
    @chat.event_id = params[:event_id]
    if @chat.save
      @chat.notice_created_by(current_farmer)
    else
      render 'error'
    end
    @chats = Chat.where(event_id: params[:event_id])
  end

  private

  def chat_params
    params.require(:chat).permit(:chat)
  end
end