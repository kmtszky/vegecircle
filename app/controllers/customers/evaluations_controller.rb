class Customers::EvaluationsController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_evaluation, only: [:edit, :update, :destroy]

  def create
    if Evaluation.where(customer_id: current_customer.id, farmer_id: @farmer.id).exists?
      redirect_to farmer_path(@farmer), flash: { warning: "評価は一回までです。" }
    else
      @farmer = Farmer.find(params[:farmer_id])
      @evaluation = current_customer.evaluation.new(evaluation_params)
      @evaluation.farmer_id = @farmer.id
      if @evaluation.save
        redirect_to farmer_path(@farmer), flash: { success: "レビューを投稿いたしました" }
      else
        redirect_to farmer_path(@farmer), flash: { danger: "星評価かコメントのいずれかを必ず入力してください。" }
      end
    end
  end

  def index
    @evaluations = current_customer.evaluations
  end

  def edit
    unless current_customer.id == @evaluation.customer_id
      redirect_to profiles_path(current_customer), flash: { danger: "他の方のレビューを編集することは出来ません" }
    end
  end

  def update

  end

  def destroy
    @evaluation.destroy
  end

  private

  def evaluation_params
    params.require(:evaluation).permit(:evaluation, :comment, :evaluation_image)
  end

  def set_evaluation
    @evaluation = Evaluation.find(params[:id])
  end
end
