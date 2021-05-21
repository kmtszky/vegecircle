class Reservation < ApplicationRecord

  belongs_to :customer
  belongs_to :schedule

  validates :people, presence: true, numericality: { only_integer: true, grater_than_or_equal_to: 1 }

end
