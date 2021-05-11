class Recipe < ApplicationRecord

  belongs_to :farmer
  has_many :recipe_tags, dependent: :destroy
  has_many :tags, through: :recipe_tags
  has_many :recipe_favorites, dependent: :destroy

  with_options presence: true do
    validates :title
    validates :recipe_image_id
    validates :duration, numericality: true
    validates :amount, numericality: true
    validates :ingredient
    validates :recipe
  end

  attachment :recipe_image
end
