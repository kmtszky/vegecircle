require 'test_helper'

class Customers::ReservationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get customers_reservations_index_url
    assert_response :success
  end

  test "should get new" do
    get customers_reservations_new_url
    assert_response :success
  end

  test "should get confirm" do
    get customers_reservations_confirm_url
    assert_response :success
  end

  test "should get thanx" do
    get customers_reservations_thanx_url
    assert_response :success
  end

  test "should get show" do
    get customers_reservations_show_url
    assert_response :success
  end

end
