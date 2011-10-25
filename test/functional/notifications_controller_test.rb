require 'test_helper'

class NotificationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_redirected_to login_url

    login_as Factory(:user)
    get :index
    assert_response :success, @response.body
  end
end
