class Tag < ApplicationRecord

  has_many :recipe_tags, dependent: :destroy
  has_many :recipes, through: :recipe_tags

  validates :tag, uniqueness: true, presence: true
end
