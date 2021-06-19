class News < ApplicationRecord

  belongs_to :farmer
  attachment :news_image

  validates :news, presence: true

  def notice_created_by(farmer)
    notifice = Notice.new(action: "お知らせ")
    followers = farmer.follows.select(:customer_id)
    if followers.present?
      followers.each do |follower|
        notifice.customer_id = follower.customer_id
      end
      notifice.save
    end
  end
end
