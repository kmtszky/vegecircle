class Farmers::EventsController < ApplicationController
  before_action :authenticate_farmer!
  before_action :set_event, only: [:show, :edit, :update, :destroy, :withdraw]
  before_action :set_schedule, only: [:show, :edit, :update, :destroy, :withdraw]
  skip_before_action :set_prefectures

  def new
    @event = Event.new
  end

  def create
    @event = current_farmer.events.new(event_params)
    if @event.save
      @event.create_schedules(current_farmer)
      if @event.has_schedules?
        number_of_days = @event.end_date - @event.start_date
        if @event.schedules.size == number_of_days + 1
          redirect_to farmers_event_path(@event), flash: { success: '農業体験を作成しました' }
        else
          @event.date_update
          redirect_to farmers_event_path(@event), flash: { danger: '既に作成済みのイベントと日付が重なっていたもの以外作成しました' }
        end
      else
        @event.destroy
        flash.now[:danger] = '作成済みのイベントと日程が重なっており、作成できませんでした（イベントは1日ひとつまで）'
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
    @events = current_farmer.events.where("end_date >= ?", Date.current).order(:start_date).page(params[:page])
    @ended_events = current_farmer.events.where("end_date < ?", Date.current).order(:start_date).page(params[:page])
  end

  def edit
    if current_farmer.id != @event.farmer_id
      redirect_to farmers_event_path(@event), flash: { danger: '他の農家さんの農業体験なので編集できません' }
    elsif @event.start_date <= Date.current
      redirect_to farmers_event_path(@event), flash: { warning: 'イベント実施中/終了済みのため編集できません' }
    else
      @schedules = Schedule.where(event_id: @event.id).pluck(:date)
    end
  end

  def update
    if @event.update(event_params)
      redirect_to farmers_event_path(@event), flash: { success: '農業体験を更新しました' }
      @event.notice_create
    else
      @schedules = Schedule.where(event_id: @event.id).pluck(:date)
      render :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to farmers_farmers_calender_path, flash: { success: '農業体験を削除しました'}
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
