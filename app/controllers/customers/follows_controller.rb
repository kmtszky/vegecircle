class Customers::FollowsController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_farmer

  def create
    follow = @farmer.follows.new(customer_id: current_customer.id)
    follow.save
    @farmer.find_or_create_by_notice(current_customer)
  end

  def destroy
    follow = @farmer.follows.find_by(customer_id: current_customer.id)
    follow.destroy
  end

  private

  def set_farmer
    @farmer = Farmer.find(params[:farmer_id])
  end
end
