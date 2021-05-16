class Customers::ReservationsController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_reservation, only: [:show, :destroy]

  def new
    @reservation = Reservation.new
  end

  def create
    @reservation = current_customer.reservations.new
  end

  def thanx
  end

  def show
  end

  def index
    @reservations = Reservation.where(customer_id: current_customer.id)
  end

  def destroy
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end
end
