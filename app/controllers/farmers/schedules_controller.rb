class Farmers::SchedulesController < ApplicationController
  before_action :authenticate_farmer!
  before_action :set_schedule

  def index

  end

  def show
  end

  def edit
    if current_farmer.id != @event.farmer_id
      redirect_to farmers_event_schedule_path(@schedule), flash: { danger: "作成者のみ編集が可能です" }
    elsif @schedule.date <= Date.current
      redirect_to farmers_event_schedule_path(@schedule), flash: { warning: "開始日当日以降のため編集できません" }
    end
  end

  def update
    if @schedule.update(schedule_params)
      if @schedule.date < @event.start_date
        @event.update(start_date: @schedule.date)
      elsif @schedule.date > @event.end_date
        @event.update(end_date: @schedule.date)
      end
      redirect_to farmers_event_schedule_path(@schedule),
        flash: { success: "#{@schedule.date.strftime("%Y/%m/%d")}の日程を更新しました。チャットへのご連絡をお願いいたします" }
    else
      render :edit
    end
  end

  private

  def set_schedule
    @schedule = Schedule.find(params[:id])
    @event = Event.find(params[:event_id])
  end

  def schedule_params
    params.require(:schedule).permit(:date, :start_time, :end_time, :people, :is_deleted)
  end
end