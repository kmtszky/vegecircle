class Customers::ReservationsController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_schedule, only: [:new, :confirm, :back, :show, :destroy]
  before_action :set_reservation, only: [:show, :thanx, :destroy]

  def new
    if current_customer.reservations.where(schedule_id: params[:schedule_id]).exists?
      @reservation = current_customer.reservations.where(schedule_id: params[:schedule_id])
      redirect_to reservations_path(current_customer), flash: { warning: "予約済みのため予約一覧ページへ移動しました。" }
    end
    session.delete(:reservation)
    @reservation = Reservation.new
    reserved_number = @schedule.reservations.pluck(:people).sum
    @reservable_number = @schedule.people - reserved_number
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
      redirect_to event_schedule_reservations_thanx_path
    else
      render :confirm
    end
  end

  def thanx
  end

  def show
  end

  def index
    @reservations = current_customer.reservations
  end

  def destroy
    @resevation.destroy
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
