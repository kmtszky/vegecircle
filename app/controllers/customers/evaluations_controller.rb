class Customers::EvaluationsController < ApplicationController
  before_action :authenticate_customer!

  def create
    @farmer = Farmer.find(params[:farmer_id])
    @evaluation = current_customer.evaluation.new(evaluation_params)
    @evaluation.farmer_id = @farmer.id
    if Evaluation.where(customer_id: current_customer.id, farmer_id: @farmer.id).exists?
      redirect_to farmer_path(@farmer), flash: { alart: "評価は一回までです。" }
    elsif @evaluation.save
      redirect_to farmer_path(@farmer)
    else
      redirect_to farmer_path(@farmer), flash: { alart: "星評価かコメントのいずれかを必ず入力してください。" }
    end
  end

  def destroy
    @evaluation = Evaluation.find(params[:id])
    @evaluation.destroy
  end

  private

  def evaluation_params
    params.require(:evaluation).permit(:evaluation, :comment, :evaluation_image)
  end
end
