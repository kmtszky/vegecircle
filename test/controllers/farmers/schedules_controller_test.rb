require 'test_helper'

class Farmers::SchedulesControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get farmers_schedules_edit_url
    assert_response :success
  end

end
