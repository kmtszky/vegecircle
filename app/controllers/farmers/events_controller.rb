class Farmers::EventsController < ApplicationController
  before_action :authenticate_farmer!
  before_action :set_event, only: [:show, :edit, :update, :destroy, :withdraw]
  before_action :set_schedule, only: [:show, :edit, :update, :destroy, :withdraw]

  def new
    @event = Event.new
  end

  def create
    @event = current_farmer.events.new(event_params)
    if @event.save
      start_date = @event.start_date
      end_date = @event.end_date
      number_of_days = end_date - start_date

      start_date.step(start_date + number_of_days, 1) do |day|
        @schedule = Schedule.new(date: day, event_id: @event.id)
        @schedule.start_time = @event.start_time
        @schedule.end_time = @event.end_time
        @schedule.people = @event.number_of_participants
        @schedule.save
      end
      redirect_to farmers_event_path(@event)
    else
      render :new
    end
  end

  def show
    @schedule = @schedules.first
    @chats = Chat.where(event_id: params[:id])
    if current_farmer.id == @event.farmer_id
      @chat = Chat.new
    end
  end

  def index
    @events = Event.where("end_date >= ?", Date.current).order(:start_date).page(params[:page]).reverse_order
  end

  def edit
    if current_farmer.id != @event.farmer_id
      redirect_to farmers_event_path(@event), flash: { danger: '他の農家さんの農業体験へ編集できません' }
    elsif @event.start_date <= Date.current
      redirect_to farmers_event_path(@event), flash: { warning: 'イベント期間中～以降のため編集できません' }
    else
      @schedules = Schedule.where(event_id: @event.id).pluck(:date)
    end
  end

  def update
    if @event.update(event_params)
      redirect_to farmers_event_path(@event), flash: { success: '農業体験を更新しました' }
    else
      @schedules = Schedule.where(event_id: @event.id).pluck(:date)
      render :edit
    end
  end

  def destroy
    if @event.start_date > Date.current
      @event.destroy
      redirect_to farmers_farmer_path(current_farmer), flash: { success: '農業体験を削除しました'}
    else
      @schedules = Schedule.where(event_id: @event.id).pluck(:date)
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
    params.require(:event).permit(:title, :plan_image, :body, :fee, :cancel_change, :start_date, :end_date, :location, :access, :parking, :etc, :is_deleted, :start_time, :end_time, :number_of_participants)
  end
end
