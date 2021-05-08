require 'test_helper'

class Farmers::EventsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get farmers_events_new_url
    assert_response :success
  end

  test "should get confirm" do
    get farmers_events_confirm_url
    assert_response :success
  end

  test "should get edit" do
    get farmers_events_edit_url
    assert_response :success
  end

end
