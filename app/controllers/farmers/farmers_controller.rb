class Farmers::FarmersController < ApplicationController
  before_action :set_farmer

  def show
  end

  def edit
  end

  def update
    if @farmer.update(farmer_params)
      redirect_to farmer_path(current_farmer), flash: {success: "登録情報を更新しました"}
    else
      render :edit
    end
  end

  def unsubscribe
  end

  def withdraw
    @farmer.update(is_deleted: true)
    reset_session
    flash[:notice] = "ご利用いただき大変ありがとうございました！またのご利用を心よりお待ちしております。"
    redirect_to root_path
  end

  private

  def set_farmer
    @farmer = Farmer.find(params[:id])
  end

  def farmer_params
    params.require(:farmer).permit(:name, :phone, :farm_address, :store_address, :introduction, :farmer_image, :image_1, :image_2, :image_3)
  end
end
