class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :timeoutable
  after_create :send_registration_email

  has_many :chats, dependent: :destroy
  has_many :evaluations, dependent: :destroy
  has_many :event_favorites, dependent: :destroy
  has_many :favorite_events, through: :event_favorites, source: :event
  has_many :follows, dependent: :destroy
  has_many :follow_farmers, through: :follows, source: :farmer
  has_many :recipe_favorites, dependent: :destroy
  has_many :favorite_recipes, through: :recipe_favorites, source: :recipe
  has_many :reservations, dependent: :destroy

  validates :nickname, uniqueness: true, presence: true
  attachment :customer_image

  def send_registration_email
    Farmers::WelcomeMailer.complete_registration(current_farmer).deliver
  end

  def active_for_authentication?
    super && (self.is_deleted == false)
  end

  def following?(farmer)
    follows.where(farmer_id: farmer.id).exists?
  end

  def reserved?(schedule)
    reservations.where(schedule_id: schedule.id).exists?
  end

  def self.deliver_mail
    tomorrow_schedules = Schedule.all.select do |sch|
      sch.date - Date.current == 1
    end
    tomorrow_schedules_ids = tomorrow_schedules.pluck(:id)
    ids_of_customers_have_tomorrow_reservation = Reservation.where(schedule_id: tomorrow_schedules_ids).pluck(:customer_id)
    customers_have_tomorrow_reservation = Customer.where(id: ids_of_customers_have_tomorrow_reservation)

    customers_have_tomorrow_reservation.each do |customer|
      reservation = Reservation.where(schedule_id: tomorrow_schedules_ids).find_by(customer_id: customer.id)
      schedule = Schedule.find(reservation.schedule_id)
      event = Event.find(schedule.event_id)
      Customers::RemindMailer.remind_reservation(customer, reservation, schedule, event).deliver_now
    end
  end
end