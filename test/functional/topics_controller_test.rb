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

  test "should create topic" do
    post :create, :topic => Factory.attributes_for(:topic)
    assert_redirected_to login_url

    login_as @user
    assert_difference "current_user.topics.count" do
      post :create, :topic => Factory.attributes_for(:topic)
    end
  end

  test "should show topic" do
    topic = Factory :topic
    get :show, :id => topic.id
    assert_response :success, @response.body
  end
end
