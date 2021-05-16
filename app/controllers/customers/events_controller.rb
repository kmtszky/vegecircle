class Customers::EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
    @schedule = Schedule.where(event_id: params[:event_id], is_deleted: false)
  end
end
