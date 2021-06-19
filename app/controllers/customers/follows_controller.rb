class Customers::FollowsController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_farmer

  def create
    follow = @farmer.follows.new(customer_id: current_customer.id)
    follow.save
    @farmer.find_or_create_notice_of_follow(current_customer)
  end

  def destroy
    @farmer.follows.find_by(customer_id: current_customer.id).destroy
  end

  private

  def set_farmer
    @farmer = Farmer.find(params[:farmer_id])
  end
end
