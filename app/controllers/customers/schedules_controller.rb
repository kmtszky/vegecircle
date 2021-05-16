class Customers::SchedulesController < ApplicationController
  def show
    @event = Event.find(params[:event_id])
    @schedule = @event.schedules.find(params[:id])
  end
end
