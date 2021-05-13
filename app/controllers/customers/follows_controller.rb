class Customers::FollowsController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_farmer

  def index
    @follows = Follow.all
  end

  def create
    follow = @farmer.follows.new(customer_id: current_customer.id)
    follow.save
    redirect_to farmers_path(@farmer)
  end

  def destroy
    follow = @farmer.follows.find_by(customer_id: current_customer.id)
    follow.destroy
    redirect_to farmers_path(@farmer)
  end

  private

  def set_farmer
    @farmer = Farmer.find(params[:farmer_id])
  end
end
