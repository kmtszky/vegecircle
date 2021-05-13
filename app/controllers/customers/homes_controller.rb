class Customers::HomesController < ApplicationController
  def top
    recipe_index = Recipe.all.order('created_at DESC')
    @recipes = recipe_index.first(4)
  end

  def about
  end
end
