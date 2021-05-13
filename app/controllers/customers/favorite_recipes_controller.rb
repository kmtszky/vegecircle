class Customers::FavoriteRecipesController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_recipe

  def create
    favorite = @recipe.recipe_favorites.new(customer_id: current_customer.id)
    favorite.save
  end

  def destroy
    favorite = @recipe.recipe_favorites.find_by(customer_id: current_customer.id)
    favorite.destroy
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end
end
