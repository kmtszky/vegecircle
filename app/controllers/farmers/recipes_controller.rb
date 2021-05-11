class Farmers::RecipesController < ApplicationController
  before_action :authenticate_farmer!, exept: [:show]
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]

  def new
    @recipe = Recipe.new
  end

  def confirm
  end

  def create
    @recipe = current_farmer.recipes.new(recipe_params)
    if @recipe.save
      redirect_to farmers_recipe_path(params[:id]), flash: {success: "レシピを作成しました"}
    else
      render :new
    end
  end

  def show

  end

  def edit
  end

  def update
    if @recipe.updade(recipe_params)
      redirect_to farmers_recipe_path(params[:id]), flash: {success: "レシピを更新しました"}
    else
      render :edit
    end
  end

  def destroy
    if @recipe.destroy
      redirect_to farmer_path(current_farmer), flash: {success: "レシピを削除しました"}
    end
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(:title, :recipe_image_id, :duration, :amount, :ingredient, :recipe)
  end
end
