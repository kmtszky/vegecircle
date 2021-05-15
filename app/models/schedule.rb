class Schedule < ApplicationRecord

  belongs_to :event

  with_options presence: true do
    validates :date
    validates :start_time
    validates :end_time
  end
end
