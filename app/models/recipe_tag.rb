class RecipeTag < ApplicationRecord

  belongs_to :recipe
  belongs_to :tag
  attachment :recipe_image
end
