class Evaluation < ApplicationRecord
  belongs_to :customer
  belongs_to :farmer

  validates :evaluation, presence: true, unless: :comment?
  validates :comment, presence: true, unless: :evaluation?
  attachment :evaluation_image
end
