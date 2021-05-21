class Customers::EventsController < ApplicationController
  def index
    @events = Event.where("end_date > ?", Date.today).page(params[:page]).reverse_order
  end

  def show
    @event = Event.find(params[:id])
    @schedules = @event.schedules.where(is_deleted: false).where("date >= ?", Date.today)
    @schedule = @schedules.first
    @chat = Chat.new
    @chats = Chat.where(event_id: params[:id])
  end
end
