class Customers::FavoriteEventsController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_event
  skip_before_action :set_prefectures

  def create
    favorite = @event.event_favorites.new(customer_id: current_customer.id)
    favorite.save
  end

  def destroy
    favorite = @event.event_favorites.find_by(customer_id: current_customer.id)
    favorite.destroy
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end
end
