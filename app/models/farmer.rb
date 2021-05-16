class Farmer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :chats, dependent: :destroy
  has_many :evaluations, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :follows, dependent: :destroy
  has_many :news, dependent: :destroy
  has_many :recipes, dependent: :destroy

  with_options presence: true do
    validates :farm_address
    validates :store_address, uniqueness: true
  end

  attachment :farmer_image
  attachment :image_1
  attachment :image_2
  attachment :image_3

  def active_for_authentication?
    super && (self.is_deleted == false)
  end
end
