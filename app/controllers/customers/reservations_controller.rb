class Customers::ReservationsController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_schedule, only: [:new, :confirm, :back]
  before_action :set_reservation, only: [:show, :thanx, :edit, :update, :destroy]

  def new
    if current_customer.reservations.where(schedule_id: params[:schedule_id]).exist?
      @reservation = Reservation.find(params[:id])
      redirect_to edit_event_schedule_reservation_path(@event, @schedule, @reservation), flash: { warning: "予約済みのため編集ページへ移動します" }
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

  def edit
  end

  def update
    reserved_number = @schedule.reservations.pluck(:people).sum
    reservable_number = @schedule.people - reserved_number
    if params[:event][:schedule][:reservation][:people].to_i > reservable_number
      if params@reservations.update(reservation_params)
        redirect_to event_schedule_reservation_path(@reservation)
      else
        render :edit
      end
    end
  end

  def destroy
    @resevation.destroy
    redirect_to profiles_path(current_customer), flash: { success: "ご予約をキャンセルしました" }
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
