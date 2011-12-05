require 'test_helper'

class NotificationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_redirected_to login_url

    user = Factory :user
    login_as user
    Factory :notification_mention, :user => user, :mentionable => Factory(:topic)
    Factory :notification_mention, :user => user, :mentionable => Factory(:reply)
    Factory :notification_mention, :user => user, :mentionable => Factory(:comment)
    Factory :notification_topic_reply, :user => user
    Factory :notification_resource_comment, :user => user
    Factory :notification_comment_comment, :user => user
    get :index
    assert_response :success, @response.body
  end

  test "should mark as read when visit notifications index" do
    user = Factory :user
    3.times{ Factory :notification_mention, :user => user, :mentionable => Factory(:reply)}
    login_as user
    assert_difference "user.notifications.unread.count", -3 do
      get :index
    end
  end

  test "should mark all as read" do
    user = Factory :user
    3.times{ Factory :notification_mention, :user => user, :mentionable => Factory(:reply)}
    login_as user
    
    assert_difference "user.notifications.unread.count", -3 do
      put :mark_all_as_read
    end
  end

  test "should delete notification" do
    user = Factory :user
    notification = Factory :notification_base, :user => user

    delete :destroy, :id => notification
    assert_redirected_to login_url

    login_as user
    assert_difference "user.notifications.count", -1 do
      delete :destroy, :id => notification
    end
  end
end
