require 'test_helper'

class Farmers::RecipesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get farmers_recipes_new_url
    assert_response :success
  end

  test "should get confirm" do
    get farmers_recipes_confirm_url
    assert_response :success
  end

  test "should get edit" do
    get farmers_recipes_edit_url
    assert_response :success
  end

end
