class Farmers::ChatsController < ApplicationController
  before_action :authenticate_farmer!
  before_action :set_farmer

  def create
    if current_farmer == @farmer
      @chat = current_farmer.chats.new(chat_params)
      @chat.event_id = params[:event_id]
      if @chat.save
        redirect_to request.referer
      else
        @event = Event.find(params[:event_id])
        @schedules = Schedule.where(event_id: @event.id)
        @schedule = @schedules.first
        @chats = Chat.where(event_id: params[:event_id])
        render template: "farmers/events/show"
      end
    end
  end

  def destroy
    chat = Chat.find(params[:id])
    if chat.farmer_id == current_farmer.id
      chat.destroy
      redirect_to request.referer
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