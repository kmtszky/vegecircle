class News < ApplicationRecord
  belongs_to :farmer
  validates :news, presence: true
  attachment :news_image

  def notice_created_by(farmer)
    followers = farmer.follows.select(:customer_id)
    if followers.exists?
      notice = Notice.new(farmer_id: farmer.id, action: "お知らせ")
      followers.each do |follower|
        notice.customer_id = follower.customer_id
        notice.save
      end
    end
  end
end
