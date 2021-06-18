class Farmer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :timeoutable

  has_many :chats, dependent: :destroy
  has_many :evaluations, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :schedules, through: :events
  has_many :reservations, through: :schedules
  has_many :follows, dependent: :destroy
  has_many :news, dependent: :destroy
  has_many :notices, dependent: :destroy
  has_many :recipes, dependent: :destroy

  with_options presence: true do
    validates :name
    validates :farm_address
    validates :store_address, uniqueness: true
  end

  geocoded_by :store_address, latitude: :store_latitude, longitude: :store_longitude
  after_validation :geocode

  attachment :farmer_image
  attachment :image_1
  attachment :image_2
  attachment :image_3

  def active_for_authentication?
    super && (self.is_deleted == false)
  end

  def has_schedules_on_the_day?(day)
    schedules.where(date: day).exists?
  end

  def self.search_for(content, method)
    case method
    when 'forward'
      Farmer.where(is_deleted: false).where('store_address like ?', content + '%')
    else
      Farmer.where(is_deleted: false).where('name like ?', '%' + content + '%')
    end
  end

  def self.sorts(method)
    case method
    when 'new'
      Farmer.all.order('created_at DESC')
    when 'old'
      Farmer.all.order(:created_at)
    when 'follows'
      Farmer.where(is_deleted: false).includes(:follows).sort {|a, b| b.follows.size <=> a.follows.size }
    else
      Farmer.where(is_deleted: false).includes(:evaluations).sort {|a, b| b.evaluations.size <=> a.evaluations.size }
    end
  end
end
