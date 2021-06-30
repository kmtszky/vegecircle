class Customers::EventsController < ApplicationController
  def index
    @events = Event.where('end_date >= ?', Date.current).order(:start_date).page(params[:page])
  end

  def show
    @event = Event.find(params[:id])
    @schedules = @event.schedules.where(is_deleted: false, is_full: false)
    @schedule = @event.schedules.first
    @chat = Chat.new
    @chats = Chat.where(event_id: params[:id])
  end
end
