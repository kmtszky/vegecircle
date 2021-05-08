require 'test_helper'

class Admins::FarmersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admins_farmers_index_url
    assert_response :success
  end

end
