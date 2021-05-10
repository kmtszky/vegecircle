require 'test_helper'

class Customers::HomesControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get customers_homes_top_url
    assert_response :success
  end

  test "should get about" do
    get customers_homes_about_url
    assert_response :success
  end

end
