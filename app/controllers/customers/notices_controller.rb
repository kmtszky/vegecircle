class Customers::NoticesController < ApplicationController
  def index
    @notices = current_customer.notices.order('created_at DESC').first(20)
    unchecked_notices = @notices.where(checked: false)
    unchecked_notices.update_all(checked: true)
  end

  def destroy_all
    @notices = current_customer.notices.destroy_all
    redirect_to profiles_path(current_customer), flash: { success: '通知をすべて削除しました' }
  end
end
