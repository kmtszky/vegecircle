class Farmers::EventsController < ApplicationController
  before_action :authenticate_farmer!, exept: [:event]
  before_action :set_event, except: [:new, :create]

  require "date"

  def new
    @event = Event.new
  end

  def create
    start_d = Data.parse(params[:event][:start_date])
    end_d = Data.parse(params[:event][:start_date])
    number_of_days = end_d - start_d

    if ( start_d < Data.today ) || ( end_d < Data.today )
      render :new
    else
      start_d.step(start_d + number_of_days, 1) do |day|
        @event = Event.new(event_params)
        @event.day = day
        @event.save
      end
    end
  end

  def edit
    if @event.date < Data.today
      redirect_to request.referer, flash: { danger: 'イベント日以降のため編集できません'}
    end
  end

  def update
    unless  @event.date < Data.today
      updated_date = Date.parse(params[:event][:date])
      if @event.update(event_params) || @event.update(date: updated_date)
        redirect_to event_path(@event), flash: { success: '農業体験を更新しました' }
      else
        render :edit
      end
    end
  end

  def withdraw
    if @event.update(is_deleted: true)
      redirect_to event_path(@event), flash: { success: '農業体験の受付を終了しました' }
    else
      render :edit
    end
  end

  def destroy
    if @event.date > Data.today
      @event.destroy
      redirect_to farmers_recipe_index_path, flash: { success: '農業体験を削除しました'}
    else
      render :edit
    end
  end

  def event_index
    @events = Event.where(farmer_id: @farmer.id)
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :plan_image, :body, :fee, :cancel_change, :start_time, :end_time, :location, :access, :parking, :etc, :is_deleted)
  end
end
