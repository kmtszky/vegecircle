class Customers::RecipesController < ApplicationController
  def index
    @recipes = Recipe.page(params[:page]).reverse_order
  end

  def show
    @recipe = Recipe.find(params[:id])
    @tag_list = @recipe.tags.pluck(:tag)
  end
end
