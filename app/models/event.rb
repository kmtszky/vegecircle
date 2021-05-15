class Event < ApplicationRecord

  belongs_to :farmer
  has_many :favorites, dependent: :destroy
  has_many :reservations, dependent: :destroy
  attachment :plan_image

  with_options presence: true do
    validates :title
    validates :plan_image
    validates :body
    validates :fee, numericality: { only_integer: true }
    validates :cancel_change
    validates :location
    validates :access
  end

  enum parking: {
    "駐車場あり、予約不要": 0,
    "駐車場あり、予約要": 1,
    "駐車場なし": 2,
  }

  def favorited_by?(customer)
    event_favorites.where(customer_id: customer.id).exists?
  end
end
