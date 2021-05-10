require 'test_helper'

class Customers::ProfilesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get customers_profiles_show_url
    assert_response :success
  end

  test "should get edit" do
    get customers_profiles_edit_url
    assert_response :success
  end

  test "should get unsubscribe" do
    get customers_profiles_unsubscribe_url
    assert_response :success
  end

end
