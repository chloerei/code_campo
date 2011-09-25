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
    get :show, :id => topic
    assert_response :success, @response.body
  end

  test "should get edit page" do
    topic = Factory :topic
    get :edit, :id => topic
    assert_redirected_to login_url

    login_as Factory(:user)
    assert_raise Mongoid::Errors::DocumentNotFound do
      get :edit, :id => topic
    end

    login_as topic.user
    get :edit, :id => topic
    assert_response :success, @response.body
  end

  test "should update topic" do
    topic = Factory :topic
    post :update, :id => topic, :topic => {:title => 'new title'}
    assert_redirected_to login_url

    login_as Factory(:user)
    assert_raise Mongoid::Errors::DocumentNotFound do
      post :update, :id => topic, :topic => {:title => 'new title'}
    end

    login_as topic.user
    post :update, :id => topic, :topic => {:title => 'new title'}
    assert_redirected_to topic
    assert_equal 'new title', topic.reload.title
  end
end
