class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :chats, dependent: :destroy
  has_many :evaluation, dependent: :destroy
  has_many :event_favorites, dependent: :destroy
  has_many :follows, dependent: :destroy
  has_many :recipe_favorites, dependent: :destroy
  has_many :reservations, dependent: :destroy

  validates :nickname, uniqueness: true, presence: true
  attachment :customer_image

  def active_for_authentication?
    super && (self.is_deleted == false)
  end

  def following?(farmer)
    follows.where(farmer_id: farmer.id).exists?
  end
end
