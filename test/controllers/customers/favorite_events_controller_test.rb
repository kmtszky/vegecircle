require 'test_helper'

class Customers::FavoriteEventsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get customers_favorite_events_index_url
    assert_response :success
  end

end
