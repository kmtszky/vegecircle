require 'test_helper'

class Customers::RecipesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get customers_recipes_index_url
    assert_response :success
  end

  test "should get show" do
    get customers_recipes_show_url
    assert_response :success
  end

end
