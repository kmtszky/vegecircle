require 'test_helper'

class Customers::SchedulesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get customers_schedules_index_url
    assert_response :success
  end

  test "should get show" do
    get customers_schedules_show_url
    assert_response :success
  end

end
