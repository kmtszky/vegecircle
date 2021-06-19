class News < ApplicationRecord

  belongs_to :farmer
  attachment :news_image

  validates :news, presence: true

  def notice_created_by(farmer)
    notice = Notice.new(action: "お知らせ")
    followers = farmer.follows.select(:customer_id)
    if followers.present?
      followers.each do |follower|
        notice.customer_id = follower.customer_id
      end
      notice.save
    end
  end
end
