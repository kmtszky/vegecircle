class Farmers::NoticesController < ApplicationController
  def index
    @notices = current_farmer.notices
    unchecked_notices = @notices.where(checked: false)
    unchecked_notices.update_all(checked: true)
  end

  def destroy_all
    @notices = current_farmer.notices.destroy_all
    redirect_to farmers_farmers_path(current_farmer), flash: { success: '通知をすべて削除しました' }
  end
end
