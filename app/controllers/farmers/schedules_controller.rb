class Farmers::SchedulesController < ApplicationController
  before_action :authenticate_farmer!
  before_action :set_schedule

  def show
  end

  def edit
    if @schedule.date < Date.today
      redirect_to farmers_event_path(@event)
    end
  end

  def update
    if @schedule.update(schedule_params)
      redirect_to farmers_event_path(@event), flash: { success: "イベントの日程を更新しました" }
    else
      render :edit
    end
  end

  def withdraw
    @schedule.update(is_deleted: true)
    redirect_to farmers_event_schedule_path(@event), flash: { success: "イベントの受付を終了しました" }
  end

  def restart
    @schedule.update(is_deleted: false)
    redirect_to farmers_event_schedule_path(@event), flash: { success: "イベントの受付を再開しました" }
  end

  def destroy
    @schedule.destroy
    redirect_to farmers_event_path(@event), flash: { success: "イベントを削除しました"}
  end

  private

  def set_schedule
    @schedule = Schedule.find(params[:id])
    @event = Event.find(params[:event_id])
  end

  def schedule_params
    params.require(:schedule).permit(:date, :start_time, :end_time, :is_deleted)
  end
end
