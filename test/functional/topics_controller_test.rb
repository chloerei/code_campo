require 'test_helper'

class TopicsControllerTest < ActionController::TestCase
  def setup
    @user = Factory :user
  end

  test "should get index" do
    get :index
    assert_response :success, @response.body
  end

  test "should get new topic page" do
    get :new
    assert_redirected_to login_url

    login_as @user
    get :new
    assert_response :success, @response.body
  end
end
