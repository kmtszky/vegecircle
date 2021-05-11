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

  def save_tags(recipe_tags)
    recipe_tags.each do |entered_tag|
      recipe_tag = Tag.find_or_create_by(tag: entered_tag)
      self.tags << recipe_tag
    end
  end
end
