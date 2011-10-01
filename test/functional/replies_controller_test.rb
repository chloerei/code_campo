require 'test_helper'

class RepliesControllerTest < ActionController::TestCase
  def setup
    @user = Factory :user
    @topic = Factory :topic
  end

  test "should get new page" do
    get :new, :topic_id => @topic
    assert_redirected_to login_url

    login_as @user
    get :new, :topic_id => @topic
    assert_response :success, @response.body
  end

  test "should create reply" do
    post :create, :topic_id => @topic, :reply => {:content => 'reply body'}
    assert_redirected_to login_url
    
    login_as @user
    assert_difference "@topic.replies.count" do
      post :create, :topic_id => @topic, :reply => {:content => 'reply body'}
    end
    assert_redirected_to topic_url(@topic, :anchor => @topic.replies.last.anchor)
  end
end
