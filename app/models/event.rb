class Event < ApplicationRecord

  belongs_to :farmer
  has_many :favorites, dependent: :destroy
  has_many :reservations, dependent: :destroy

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
end
