class Farmers::RecipesController < ApplicationController
  before_action :authenticate_farmer!
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  skip_before_action :set_prefectures

  def index
    @recipes = current_farmer.recipes.page(params[:page]).reverse_order
  end

  def show
    @recipe = Recipe.find(params[:id])
    @tag_list = @recipe.tags.pluck(:tag)
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = current_farmer.recipes.new(recipe_params)
    @tag_list = params[:recipe][:tag_list].split(',')
    if @recipe.save
      @recipe.save_tags(@tag_list)
      redirect_to farmers_recipe_path(@recipe), flash: {success: "レシピを作成しました"}
    else
      render :new
    end
  end

  def edit
    if current_farmer.id == @recipe.farmer_id
      @tag_list = @recipe.tags.pluck(:tag).join(",")
    else
      redirect_to farmers_recipe_path(@recipe), flash: {danger: "作成者のみ編集が可能です"}
    end
  end

  def update
    tag_list = params[:recipe][:tag_list].split(',')
    if @recipe.update_attributes(recipe_params)
      @recipe.save_tags(tag_list)
      redirect_to farmers_recipe_path(params[:id]), flash: {success: "レシピを更新しました"}
    else
      render :edit
    end
  end

  def destroy
    @recipe.destroy
    redirect_to farmers_farmers_path, flash: {success: "レシピを削除しました"}
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(:title, :recipe_image, :duration, :amount, :ingredient, :recipe, :tag_list)
  end
end
