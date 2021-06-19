class News < ApplicationRecord

  belongs_to :farmer
  attachment :news_image

  validates :news, presence: true

  def notification_created_by(farmer)
    notification = Notice.new(action: "お知らせ")
    followers = farmer.follows.select(:customer_id)
    if followers.present?
      followers.each do |follower|
        notification.customer_id = follower.customer_id
      end
      notification.save
    end
  end
end
