class Customers::RecipesController < ApplicationController
  skip_before_action :set_prefectures

  def index
    @recipes = Recipe.page(params[:page]).reverse_order
  end

  def show
    @recipe = Recipe.find(params[:id])
    @tag_list = @recipe.tags.pluck(:tag)
  end
end
