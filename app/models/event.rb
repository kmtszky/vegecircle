class Event < ApplicationRecord

  belongs_to :farmer
  has_many :favorites, dependent: :destroy
  has_many :reservations, dependent: :destroy
  attachment :plan_image

  with_options presence: true do
    validates :title
    validates :plan_image_id
    validates :body
    validates :fee, numericality: { only_integer: true }
    validates :cancel_change
    validates :date
    validates :start_time
    validates :end_time
    validates :location
    validates :access
  end

  def favorited_by?(customer)
    event_favorites.where(customer_id: customer.id).exists?
  end
end
