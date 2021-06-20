class Farmers::NoticesController < ApplicationController
  def index
    notices = current_farmer.notices
    @notices = notices.where(action: ["フォロー", "チャット", "予約"]).order('created_at DESC').first(20)
    if notices.exists?
      unchecked_notices = notices.where(checked: false)
      unchecked_notices.update_all(checked: true)
    end
  end

  def destroy_all
    current_farmer.notices.where(action: ["フォロー", "チャット", "予約"]).destroy_all
    redirect_to farmers_farmers_path, flash: { success: '通知をすべて削除しました' }
  end
end
