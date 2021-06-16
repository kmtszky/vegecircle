# frozen_string_literal: true

class Customers::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

   def after_sign_in_path_for(resource)
    profiles_path(current_customer)
   end

   def after_sign_out_path_for(resource)
    root_path
   end

   def guest_sign_in
    customer = Customer.guest_account
    customer.update(is_deleted: false)
    sign_in customer
    redirect_to profiles_path(current_customer), notice: 'ゲスト住民としてログインしました'
   end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
