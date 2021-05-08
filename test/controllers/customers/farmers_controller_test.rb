require 'test_helper'

class Customers::FarmersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get customers_farmers_index_url
    assert_response :success
  end

  test "should get show" do
    get customers_farmers_show_url
    assert_response :success
  end

end
