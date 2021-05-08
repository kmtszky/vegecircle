class News < ApplicationRecord

  belongs_to :farmer

  validates :news, presence: true
end
