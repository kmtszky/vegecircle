class Customers::ReservationsController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_schedule, only: [:new, :confirm, :back, :create, :thanx, :show, :destroy]
  before_action :set_reservation, only: [:show, :destroy]

  def new
    if current_customer.reservations.where(schedule_id: params[:schedule_id]).exists?
      @reservation = current_customer.reservations.where(schedule_id: params[:schedule_id])
      redirect_to reservations_path(current_customer), flash: { warning: "予約済みのため予約一覧ページへ移動しました。" }
    end
    session.delete(:reservation)
    @reservation = Reservation.new
    reserved_number = @schedule.reservations.pluck(:people).sum
    @reservable_number = @schedule.people - reserved_number

    @farmer = Farmer.find_by(id: @event.farmer_id)
    @evaluation = Evaluation.new
  end

  def back
    @reservation = Reservation.new(session[:reservation])
    session.delete(:reservation)
    reserved_number = @schedule.reservations.pluck(:people).sum
    @reservable_number = @schedule.people - reserved_number
    render :new
  end

  def confirm
    @reservation = current_customer.reservations.new(reservation_params)
    @reservation.schedule_id = params[:schedule_id]
    session[:reservation] = @reservation
    if @reservation.invalid?
      reserved_number = @schedule.reservations.pluck(:people).sum
      @reservable_number = @schedule.people - reserved_number
      render :new
    end
  end

  def create
    @reservation = Reservation.new(session[:reservation])
    if @reservation.save
      session.delete(:reservation)
      Customers::ThanxMailer.complete_reservation(@reservation).deliver
      redirect_to event_schedule_reservations_thanx_path

      reserved_number = @schedule.reservations.pluck(:people).sum
      if @schedule.people == reserved_number
        @schedule.update(is_full: true)
      end
    else
      render :confirm
    end
  end

  def thanx
    @reservation = Reservation.find_by(schedule_id: params[:schedule_id])
  end

  def show
  end

  def index
    reservation_ids = current_customer.reservations.pluck(:schedule_id)
    schedule_ids = Schedule.where(id: reservation_ids).where(is_deleted: false).pluck(:id)
    @reservations = Reservation.where(schedule_id: schedule_ids)

    past_schedule_ids = Schedule.where(id: reservation_ids).where(is_deleted: true).pluck(:id)
    @past_reservations = Reservation.where(schedule_id: past_schedule_ids)
  end

  def destroy
    Reservation.find(params[:id]).destroy
    redirect_to reservations_path(current_customer), flash: { success: "ご予約をキャンセルしました" }
  end

  private

  def set_schedule
    @event = Event.find(params[:event_id])
    @schedule = Schedule.find(params[:schedule_id])
  end

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:people)
  end
end
