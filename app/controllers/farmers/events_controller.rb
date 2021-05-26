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

      start_date.step(start_date + number_of_days, 1) do |date|
        schedule = Schedule.new(date: date, event_id: @event.id, people: @event.number_of_participants)
        schedule.start_time = DateTime.new(date.year, date.month, date.day, @event.start_time.split(":")[0].to_i, @event.start_time.split(":")[1].to_i, 00, "+09:00")
        schedule.end_time = DateTime.new(date.year, date.month, date.day, @event.end_time.split(":")[0].to_i, @event.end_time.split(":")[1].to_i, 00, "+09:00")
        unless schedule.save
          next
        end
      end

      schedules = Schedule.where(event_id: @event.id)
      if schedules.exists?
        if schedules.count == number_of_days + 1
          redirect_to farmers_event_path(@event)
        else
          if schedules.first.date > @event.start_date
            @event.update(start_date: schedules.first.date)
          elsif schedules.last.date < @event.end_date
            @event.update(end_date: schedules.last.date)
          end
          redirect_to farmers_event_path(@event), flash: { danger: '既に作成済みのイベントと日付が重なっていたもの以外作成しました）' }
        end
      else
        flash.now[:danger] = '作成済みのイベントと日程が重なっています（イベントは1日ひとつまで）'
        render :new
      end
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
    @events = Event.where(farmer_id: current_farmer.id).where("end_date >= ?", Date.current).order(:start_date).page(params[:page]).reverse_order
  end

  def edit
    if current_farmer.id != @event.farmer_id
      redirect_to farmers_event_path(@event), flash: { danger: '他の農家さんの農業体験へ編集できません' }
    elsif @event.start_date <= Date.current
      redirect_to farmers_event_path(@event), flash: { warning: 'イベント実施中/終了済みのため編集できません' }
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
    @event.destroy
    redirect_to farmers_farmers_calender_path(current_farmer), flash: { success: '農業体験を削除しました'}
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
