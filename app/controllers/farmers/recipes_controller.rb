class Farmers::RecipesController < ApplicationController
  before_action :authenticate_farmer!, exept: [:show]
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]

  def new
    session.delete(:tag_list)
    session.delete(:recipe)
    @recipe = Recipe.new
  end

  def confirm
    @recipe = current_farmer.recipes.new(recipe_params)
    @tag_list = params[:recipe][:tag_ids].split(',')
    session[:recipe] = @recipe
    session[:tag_list] = @tag_list
    if @recipe.invalid? || @tag_list.blank?
      render :new
    end
  end

  def back
    @recipe = current_farmer.recipes.new(session[:recipe])
    session.delete(:recipe)
    session.delete(:tag_list)
    render :new
  end

  def create
    @recipe = Recipe.new(session[:recipe])
    if @recipe.save
      @recipe.save_tags(session[:tag_list])
      session.delete(:recipe)
      session.delete(:tag_list)
      redirect_to farmers_recipe_path(params[:id]), flash: {success: "レシピを作成しました"}
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
    params.require(:recipe).permit(:title, :recipe_image, :duration, :amount, :ingredient, :recipe)
  end
end
