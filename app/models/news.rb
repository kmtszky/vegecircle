class News < ApplicationRecord

  belongs_to :farmer
  attachment :news_image

  validates :news, presence: true
end
