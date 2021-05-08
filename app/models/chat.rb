class Chat < ApplicationRecord
  belongs_to :customer
  belongs_to :farmer

  validates :chat, presence: true
end
