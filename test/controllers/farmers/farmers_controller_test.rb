require 'test_helper'

class Farmers::FarmersControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get farmers_farmers_show_url
    assert_response :success
  end

  test "should get edit" do
    get farmers_farmers_edit_url
    assert_response :success
  end

  test "should get unsubscribe" do
    get farmers_farmers_unsubscribe_url
    assert_response :success
  end

end
