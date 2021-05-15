class Farmers::EventsController < ApplicationController
  before_action :authenticate_farmer!, exept: [:event_index]
  before_action :set_event, only: [:show, :edit, :update, :destroy, :withdraw]
  before_action :set_schedule, only: [:edit, :update, :destroy, :withdraw]

  def new
    @event = Event.new
  end

  def create
    @event = current_farmer.events.new(event_params)
    if @event.save
      start_d = @event.start_date
      end_d = @event.end_date
      number_of_days = end_d - start_d

      start_d.step(start_d + number_of_days, 1) do |day|
        @schedule = Schedule.new(date: day, event_id: @event.id)
        @schedule.start_time = @event.start_time
        @schedule.end_time = @event.end_time
        @schedule.save
      end
      redirect_to farmers_event_path(@event)
    else
      render :new
    end
  end

  def show
    @schedule = Schedule.find_by(event_id: @event.id)
    @schedules = Schedule.where(event_id: @event.id).pluck(:date)
  end

  def edit
    @schedules = Schedule.where(event_id: @event.id)
    start_date = @schedules.pluck(:date).first
    if start_date < Date.today
      redirect_to request.referer, flash: { danger: 'イベント開始日以降のため編集できません'}
    else

    end
  end

  def update
    unless  @event.date < Date.today
      updated_date = Date.parse(params[:event][:date])
      if @event.update(event_params) || @event.update(date: updated_date)
        redirect_to event_path(@event), flash: { success: '農業体験を更新しました' }
      else
        render :edit
      end
    end
  end

  def destroy
    if @event.date > Date.today
      @event.destroy
      redirect_to farmers_recipe_index_path, flash: { success: '農業体験を削除しました'}
    else
      render :edit
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def set_schedule
    @schedules = Schedule.where(event_id: @event.id)
  end

  def event_params
    params.require(:event).permit(:title, :plan_image, :body, :fee, :cancel_change, :start_date, :end_date, :location, :access, :parking, :etc, :is_deleted, :start_time, :end_time)
  end
end
