# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Recipe, "モデルに関するテスト", type: :model do
  describe '保存チェック' do
    it "有効な情報の場合は保存されるか" do
      expect(FactoryBot.build(:recipe)).to be_valid
    end
  end
  context "空白のバリデーションチェック" do
    it "titleが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      recipe = FactoryBot.build(:recipe)
      recipe.title = ''
      expect(recipe).to be_invalid
      expect(recipe.errors[:title]).to include("can't be blank")
    end
    it "recipe_image_idが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      recipe = FactoryBot.build(:recipe)
      recipe.recipe_image_id = ''
      expect(recipe).to be_invalid
      expect(recipe.errors[:recipe_image]).to include("can't be blank")
    end
    it "durationが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      recipe = FactoryBot.build(:recipe)
      recipe.duration = ''
      expect(recipe).to be_invalid
      expect(recipe.errors[:duration]).to include("can't be blank")
    end
    it "amountが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      recipe = FactoryBot.build(:recipe)
      recipe.amount = ''
      expect(recipe).to be_invalid
      expect(recipe.errors[:amount]).to include("can't be blank")
    end
    it "ingredientが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      recipe = FactoryBot.build(:recipe)
      recipe.ingredient = ''
      expect(recipe).to be_invalid
      expect(recipe.errors[:ingredient]).to include("can't be blank")
    end
    it "recipeが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      recipe = FactoryBot.build(:recipe)
      recipe.recipe = ''
      expect(recipe).to be_invalid
      expect(recipe.errors[:recipe]).to include("can't be blank")
    end
    it "tag_listが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      recipe = FactoryBot.build(:recipe)
      recipe.tag_list = ''
      expect(recipe).to be_invalid
      expect(recipe.errors[:tag_list]).to include("can't be blank")
    end
  end
  context "属性に数値のみが使われているバリデーションチェック" do
    it "durationが数字で入力されているかバリデーションチェックされ、数字のエラーメッセージが返ってきているか" do
      recipe = FactoryBot.build(:recipe)
      recipe.duration = 'hoge'
      expect(recipe).to be_invalid
      expect(recipe.errors[:duration]).to include("is not a number")
    end
    it "amountが数字で入力されているかバリデーションチェックされ、数字のエラーメッセージが返ってきているか" do
      recipe = FactoryBot.build(:recipe)
      recipe.amount = 'hoge'
      expect(recipe).to be_invalid
      expect(recipe.errors[:amount]).to include("is not a number")
    end
  end
end
