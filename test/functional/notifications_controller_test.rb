require 'test_helper'

class NotificationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_redirected_to login_url

    user = create :user
    login_as user
    create :notification_mention, :user => user, :mentionable => create(:topic)
    create :notification_mention, :user => user, :mentionable => create(:reply)
    create :notification_topic_reply, :user => user
    get :index
    assert_response :success, @response.body
  end

  test "should mark as read when visit notifications index" do
    user = create :user
    3.times{ create :notification_mention, :user => user, :mentionable => create(:reply)}
    login_as user
    assert_difference "user.notifications.unread.count", -3 do
      get :index
    end
  end

  test "should mark all as read" do
    user = create :user
    3.times{ create :notification_mention, :user => user, :mentionable => create(:reply)}
    login_as user

    assert_difference "user.notifications.unread.count", -3 do
      put :mark_all_as_read
    end
  end

  test "should delete notification" do
    user = create :user
    notification = create :notification_base, :user => user

    delete :destroy, :id => notification
    assert_redirected_to login_url

    login_as user
    assert_difference "user.notifications.count", -1 do
      delete :destroy, :id => notification
    end
  end
end
