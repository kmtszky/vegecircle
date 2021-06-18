require 'test_helper'

class Farmers::NoticesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get farmers_notices_index_url
    assert_response :success
  end

end
