# frozen_string_literal: true

class Farmers::SessionsController < Devise::SessionsController
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
    farmers_farmers_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  def guest_sign_in
    farmer = Farmer.find_or_create_by!(email: 'guest@example.com') do |farmer|
      farmer.name = 'ゲスト（農家）'
      farmer.password = SecureRandom.urlsafe_base64
      farmer.farm_address = '新潟県魚沼市'
      farmer.store_address = '新潟県魚沼市清本5-12-8'
      farmer.introduction = '農家用ゲストアカウントです'
    end
    farmer.update(is_deleted: false)
    sign_in farmer
    redirect_to farmers_farmers_path, flash: { success: 'ゲスト農家としてログインしました' }
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
