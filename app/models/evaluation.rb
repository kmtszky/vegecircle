class Evaluation < ApplicationRecord

  belongs_to :customer
  belongs_to :farmer

  validates :evaluation, presence: true
end
