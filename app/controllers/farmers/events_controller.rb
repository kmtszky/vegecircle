require "date"

class Farmers::EventsController < ApplicationController
  before_action :authenticate_farmer!, exept: [:event]
  before_action :set_event, except: [:new, :create]

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)

    if @event.start_date.invalid? || @event.end_date.invalid?
      render :new
    else
      start_d = Date.parse(params[:event][:start_date])
      end_d = Date.parse(params[:event][:start_date])
      number_of_days = end_d - start_d

      start_d.step(start_d + number_of_days, 1) do |day|
        @event.day = day
        @event.save
      end
    end
  end

  def edit
    if @event.date < Date.today
      redirect_to request.referer, flash: { danger: 'イベント日以降のため編集できません'}
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

  def withdraw
    if @event.update(is_deleted: true)
      redirect_to event_path(@event), flash: { success: '農業体験の受付を終了しました' }
    else
      render :edit
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

  def event_index
    @events = Event.where(farmer_id: @farmer.id)
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :plan_image, :body, :fee, :cancel_change, :start_time, :end_time, :location, :access, :parking, :etc, :is_deleted, :start_date, :end_date)
  end
end
