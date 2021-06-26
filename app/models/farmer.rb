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

  def find_or_create_notice_of_follow(customer)
    Notice.find_or_create_by(farmer_id: self.id, customer_id: customer.id, action: 'フォロー')
  end

  def has_schedules_on_the_day?(day)
    schedules.where(date: day).exists?
  end

  def self.guest_account
    find_or_create_by!(email: 'guest@example.com') do |farmer|
      farmer.name = 'ゲスト（農家）'
      farmer.password = SecureRandom.urlsafe_base64
      farmer.farm_address = '新潟県魚沼市'
      farmer.store_address = '新潟県魚沼市清本5-12-8'
      farmer.introduction = '農家用ゲストアカウントです'
    end
  end

  def self.search_for(content, method)
    case method
    when 'forward'
      where(is_deleted: false).where('store_address like ?', content + '%')
    else
      where(is_deleted: false).where('name like ?', '%' + content + '%')
    end
  end

  def self.sorts(method)
    case method
    when 'new'
      order('created_at DESC')
    when 'old'
      order(:created_at)
    when 'follows'
      where(is_deleted: false).includes(:follows).sort {|a, b| b.follows.size <=> a.follows.size }
    else
      where(is_deleted: false).includes(:evaluations).sort {|a, b| b.evaluations.size <=> a.evaluations.size }
    end
  end
end
