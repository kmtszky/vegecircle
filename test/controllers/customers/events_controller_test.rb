require 'test_helper'

class Customers::EventsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get customers_events_index_url
    assert_response :success
  end

  test "should get show" do
    get customers_events_show_url
    assert_response :success
  end

end
