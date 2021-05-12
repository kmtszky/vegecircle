class Farmers::RecipesController < ApplicationController
  before_action :authenticate_farmer!, exept: [:show]
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = current_farmer.recipes.new(recipe_params)
    @tag_list = params[:recipe][:tag_ids].split(',')
    if @recipe.save
      @recipe.save_tags(@tag_list)
      redirect_to farmers_recipe_path(@recipe), flash: {success: "レシピを作成しました"}
    else
      render :new
    end
  end

  def show
    @tag_list = @recipe.tags.pluck(:tag)
  end

  def edit
    @tag_list = @recipe.tags.pluck(:tag).join(",")
  end

  def update
    tag_list = params[:recipe][:tag_ids].split(',')
    if @recipe.update_attributes(recipe_params)
      @recipe.save_tags(tag_list)
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
    params.require(:recipe).permit(:title, :recipe_image, :duration, :amount, :ingredient, :recipe, :tag_ids)
  end
end
