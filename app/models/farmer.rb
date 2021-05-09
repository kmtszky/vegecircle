class Farmer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :chats, dependent: :destroy
  has_many :evaluation, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :follows, dependent: :destroy
  has_many :news, dependent: :destroy
  has_many :recipes, dependent: :destroy

  with_options presence: true do
    validates :phone, uniqueness: true, format: { with: /\A\d{10,11}\z/ }
    validates :farm_address
    validates :store_address, uniqueness: true
  end
end
