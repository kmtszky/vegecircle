class Customers::SchedulesController < ApplicationController
  skip_before_action :set_prefectures

  def show
    @event = Event.find(params[:event_id])
    @schedule = @event.schedules.find(params[:id])
  end
end
