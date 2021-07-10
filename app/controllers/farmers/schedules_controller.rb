class Farmers::SchedulesController < ApplicationController
  before_action :authenticate_farmer!
  before_action :set_schedule
  skip_before_action :set_prefectures

  def show
  end

  def edit
    if current_farmer.id != @event.farmer_id
      redirect_to farmers_event_schedule_path(@event, @schedule), flash: { danger: "作成者のみ編集が可能です" }
    elsif @schedule.date <= Date.current
      redirect_to farmers_event_schedule_path(@event, @schedule), flash: { warning: "開始日当日以降のため編集できません" }
    end
  end

  def update
    if current_farmer.has_schedules_on_the_day?(params[:schedule][:date])
      if current_farmer.schedules.select(:event_id).where(date: params[:schedule][:date]).size == 1
        @schedule.date_update(params[:schedule][:start_time], params[:schedule][:end_time])
        @schedule.notice_create
        redirect_to farmers_event_schedule_path(@event, @schedule),
          flash: { success: "農業体験の日程または人数を更新しました" }
      else
        flash.now[:danger] = '作成済みのイベントと日程が重なっています（イベントは1日ひとつまで）'
        render :edit
      end
    else
      if @schedule.update(schedule_params)
        @schedule.date_update(params[:schedule][:start_time], params[:schedule][:end_time])
        @schedule.eventdate_update
        @schedule.notice_create
        redirect_to farmers_event_schedule_path(@event, @schedule),
          flash: { success: "農業体験の日程または人数を更新しました" }
      else
        render :edit
      end
    end
  end

  def destroy
    @schedule.destroy
    if @event.has_schedules?
      @event.date_update
      redirect_to farmers_event_path(@event), flash: { success: "#{@schedule.date.strftime("%Y/%m/%d")}のイベントを削除しました" }
    else
      @event.destroy
      redirect_to farmers_farmers_calender_path, flash: { success: '農業体験を削除しました'}
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