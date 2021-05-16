class Customers::EventsController < ApplicationController
  def index
    @events = Event.where("end_date > ?", Date.today).page(params[:page]).reverse_order
  end

  def show
    @event = Event.find(params[:id])
    bookable_schedules = @event.schedules.where(is_deleted: false)
    @schedules = bookable_schedules.where("date > ?", Date.today)
    @schedule = @schedules.first
  end
end
