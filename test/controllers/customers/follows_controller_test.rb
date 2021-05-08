require 'test_helper'

class Customers::FollowsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get customers_follows_index_url
    assert_response :success
  end

end
