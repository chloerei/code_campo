require 'test_helper'

class TopicsControllerTest < ActionController::TestCase
  def setup
    @user = Factory :user
  end

  test "should get index" do
    get :index
    assert_response :success, @response.body
  end

  test "should get newest topics" do
    3.times { Factory :topic }
    get :newest
    assert_response :success, @response.body

    get :newest, :format => :rss
    assert_response :success, @response.body
  end

  test "should get my topics" do
    topic = Factory :topic, :user => @user
    get :my
    assert_redirected_to login_url
    
    login_as @user
    get :my
    assert_response :success, @response.body
    assert assigns(:topics).include?(topic)
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

  test "should mark topic" do
    topic = Factory :topic
    post :mark, :id => topic
    assert_redirected_to login_url

    user = Factory :user
    login_as user
    assert_difference "Topic.mark_by(user).count" do
      post :mark, :id => topic
    end
    assert_redirected_to topic
  end

  test "should cancel mark topic" do
    topic = Factory :topic
    user = Factory :user
    topic.mark_by user
    delete :unmark, :id => topic
    assert_redirected_to login_url

    login_as user
    assert_difference "Topic.mark_by(user).count", -1 do
      delete :unmark, :id => topic
    end
    assert_redirected_to topic
  end

  test "should get marked topics" do
    topic = Factory :topic
    user = Factory :user
    topic.mark_by user
    get :marked
    assert_redirected_to login_url
    
    login_as user
    get :marked
    assert_response :success, @response.body
    assert assigns(:topics).include?(topic)
  end

  test "should get replied topics" do
    topic = Factory :topic
    user = Factory :user
    Factory :reply, :topic => topic, :user => user
    get :replied
    assert_redirected_to login_url

    login_as user
    get :replied
    assert_response :success, @response.body
    assert assigns(:topics).include?(topic)
  end

  test "should get tagged topics" do
    topic = Factory :topic
    get :tagged, :tag => topic.tags.first
    assert_response :success, @response.body
    assert assigns(:topics).include?(topic)

    get :tagged, :tag => topic.tags.first, :format => :rss
    assert_response :success, @response.body
  end

  # TODO remove
  test "should redirect when using _id" do
    topic = Factory :topic
    get :show, :id => topic.id
    assert_redirected_to topic_url(topic)
  end
end
