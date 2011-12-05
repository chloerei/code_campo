require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test "should update resource's comments_count" do
    resource = Factory :resource
    assert_equal 0, resource.comments_count
    assert_difference "resource.reload.comments_count" do
      Factory :comment, :resource => resource
    end
  end

  test "should have parent" do
    root = Factory :comment
    assert_nil root.parent

    child = Factory :comment, :parent => root, :resource => root.resource
    assert_equal root, child.parent

    grandson = Factory :comment, :parent => child, :resource => root.resource
    assert_equal child, grandson.parent
  end

  test "should send resource comment notification" do
    resource = Factory :resource
    comment = nil
    assert_difference "resource.user.notifications.unread.count" do
      comment = Factory :comment, :resource => resource
    end

    assert_no_difference "resource.user.notifications.unread.count" do
      Factory :comment, :resource => resource, :user => resource.user
    end

    # except comment comment
    assert_no_difference "resource.user.notifications.unread.count" do
      Factory :comment, :resource => resource, :parent => comment
    end
  end

  test "should send comment comment notification" do
    comment = Factory :comment
    assert_difference "comment.user.notifications.unread.count" do
      Factory :comment, :parent => comment, :resource => comment.resource
    end

    assert_no_difference "comment.user.notifications.unread.count" do
      Factory :comment, :parent => comment, :resource => comment.resource, :user => comment.user
    end
  end

  test "should not send mention notification to resource user" do
    resource = Factory :resource
    assert_no_difference "resource.user.notifications.where(:_type => 'Notification::Mention').count" do
      Factory :comment, :resource => resource, :content => "@#{resource.user.name}"
    end
  end

  test "should not send mention notification to parent comment user" do
    comment = Factory :comment
    assert_no_difference "comment.user.notifications.where(:_type => 'Notification::Mention').count" do
      Factory :comment, :parent => comment, :resource => comment.resource, :content => "@#{comment.user.name}"
    end
  end
end
