require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  test "should get show page" do
    get :show
    assert_response :success, @response.body
  end
end
