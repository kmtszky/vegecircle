class Chat < ApplicationRecord
  belongs_to :customer, optional: true
  belongs_to :farmer, optional: true

  validates :chat, presence: true
end
