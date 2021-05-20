class Customers::ChatsController < ApplicationController
  before_action :authenticate_customer!

  def create
    @chat = current_customer.chats.new(chat_params)
    @chat.event_id = params[:event_id]
    unless @chat.save
      redirect_to request.referer
    else
      @event = Event.find(params[:event_id])
      @schedules = @event.schedules.where(is_deleted: false).where("date > ?", Date.today)
      @schedule = @schedules.first
      @chats = Chat.where(event_id: params[:event_id])
      render template: "customers/events/show"
    end
  end

  def destroy
    chat = Chat.find(params[:id])
    if chat.customer_id == current_customer.id
      chat.destroy
      redirect_to request.referer
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:chat)
  end
end
