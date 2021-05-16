class Customers::FollowsController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_farmer, except: [:followings]

  def create
    follow = @farmer.follows.new(customer_id: current_customer.id)
    follow.save
    redirect_to request.referer
  end

  def destroy
    follow = @farmer.follows.find_by(customer_id: current_customer.id)
    follow.destroy
    redirect_to request.referer
  end

  private

  def set_farmer
    @farmer = Farmer.find(params[:farmer_id])
  end
end
