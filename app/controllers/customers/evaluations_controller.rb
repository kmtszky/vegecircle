class Customers::EvaluationsController < ApplicationController
  before_action :authenticate_customer!, except: [:index]
  before_action :set_farmer, only: [:create, :edit]
  before_action :set_evaluation, only: [:edit, :update, :destroy]
  skip_before_action :set_prefectures

  def create
    @evaluation = current_customer.evaluations.new(evaluation_params)
    @evaluation.farmer_id = @farmer.id
    if @evaluation.save
      redirect_to farmer_path(@farmer), flash: { success: "レビューを投稿いたしました" }
    else
      redirect_to farmer_path(@farmer), flash: { danger: "星評価かコメントのいずれかを必ず入力してください。" }
    end
  end

  def index
    @evaluations = Evaluation.where(farmer_id: params[:farmer_id])
  end

  def edit
    unless current_customer.id == @evaluation.customer_id
      redirect_to profiles_path, flash: { danger: "他の方のレビューを編集することは出来ません" }
    end
  end

  def update
    if @evaluation.update(evaluation_params)
      redirect_to evaluations_path, flash: { success: "レビューを更新しました" }
    else
      render :edit
    end
  end

  def destroy
    @evaluation.destroy
    redirect_to evaluations_path, flash: { success: "レビューを削除しました" }
  end

  private

  def evaluation_params
    params.require(:evaluation).permit(:evaluation, :comment, :evaluation_image)
  end

  def set_farmer
    @farmer = Farmer.find(params[:farmer_id])
  end

  def set_evaluation
    @evaluation = Evaluation.find(params[:id])
  end
end
