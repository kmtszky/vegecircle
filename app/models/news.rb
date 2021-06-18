class News < ApplicationRecord

  belongs_to :farmer
  attachment :news_image

  validates :news, presence: true

  def notification_created_by(farmer)
    notification = farmer.notifications.new(farmer_id: farmer.id, action: "お知らせ")
  end
end
