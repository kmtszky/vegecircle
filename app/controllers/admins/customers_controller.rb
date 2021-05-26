class Admins::CustomersController < ApplicationController
  def index
    @customers = Customer.page(params[:page]).reverse_order
  end
end
