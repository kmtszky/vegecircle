class Customers::ProfilesController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_customer

  def show
  end

  def edit
    unless current_customer == @customer
      redirect_to profiles_path(current_customer), flash: { danger: "他の方のプロフィールの変更は出来ません"}
    end
  end

  def update
    if @customer.update(customer_params)
      redirect_to profiles_path(@customer), flash: { success: "登録情報を更新しました" }
    else
      render :edit
    end
  end

  def unsubscribe
  end

  def withdraw
    @customer.update(is_deleted: true)
    redirect_to root_path, flash: { success: "ご利用いただき大変ありがとうございました！またのご利用を心よりお待ちしております。"}
  end

  def favorites
    @favorite_recipes = current_customer.favorite_recipes
    @favorite_events = current_customer.favorite_events
  end

  def followings
    @followings = current_customer.follow_farmers.where(is_deleted: false)
  end

  private

  def set_customer
    @customer = current_customer
  end

  def customer_params
    params.require(:customer).permit(:nickname, :customer_image)
  end
end
