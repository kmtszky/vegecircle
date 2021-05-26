class Admins::FarmersController < ApplicationController
  def index
    @farmers = Farmer.page(params[:page]).reverse_order
  end
end
