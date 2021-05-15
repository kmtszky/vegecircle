class Customers::EventsController < ApplicationController
  def index
  end

  def show
    @event = Event.find(params[:id])
    @schedule = Schedule.find(where)
  end
end
