class Notice < ApplicationRecord
  belongs_to :farmer, optional: true
  belongs_to :customer, optional: true
  belongs_to :event, optional: true
end
