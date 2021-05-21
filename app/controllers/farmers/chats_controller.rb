class Farmers::ChatsController < ApplicationController
  before_action :authenticate_farmer!
  before_action :set_farmer

  def create
    if current_farmer == @farmer
      @chat = current_farmer.chats.new(chat_params)
      @chat.event_id = params[:event_id]
      unless @chat.save
        render 'error'
      end
      @chats = Chat.where(event_id: params[:event_id])
    end
  end

  private

  def set_farmer
    @event = Event.find(params[:event_id])
    @farmer = Farmer.find_by(id: @event.farmer_id)
  end

  def chat_params
    params.require(:chat).permit(:chat)
  end
end