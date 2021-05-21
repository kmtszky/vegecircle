class Customers::ChatsController < ApplicationController
  before_action :authenticate_customer!

  def create
    @chat = current_customer.chats.new(chat_params)
    @chat.event_id = params[:event_id]
    unless @chat.save
      render 'error'
    end
    @chats = Chat.where(event_id: params[:event_id])
  end

  private

  def chat_params
    params.require(:chat).permit(:chat)
  end
end
