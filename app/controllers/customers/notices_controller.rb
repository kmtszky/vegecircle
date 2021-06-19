class Customers::NoticesController < ApplicationController
  def index
    notices = current_customer.notices
    @notices = notices.where(action: ["チャット", "農業体験の内容更新", "農業体験のスケジュール更新", "お知らせ"]).order('created_at DESC').first(20)
    if notices.exists?
      unchecked_notices = notices.where(checked: false)
      unchecked_notices.update_all(checked: true)
    end
  end

  def destroy_all
    current_customer.notices.where(action: ["チャット", "農業体験の内容更新", "農業体験のスケジュール更新", "お知らせ"]).destroy_all
    redirect_to profiles_path(current_customer), flash: { success: '通知をすべて削除しました' }
  end
end
