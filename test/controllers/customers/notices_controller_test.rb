require 'test_helper'

class Customers::NoticesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get customers_notices_index_url
    assert_response :success
  end

end
