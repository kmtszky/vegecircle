class Notice < ApplicationRecord
  belongs_to :farmer
  belongs_to :customer
  belongs_to :event
end
