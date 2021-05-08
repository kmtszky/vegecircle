require 'test_helper'

class Customers::FavoriteRecipesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get customers_favorite_recipes_index_url
    assert_response :success
  end

end
