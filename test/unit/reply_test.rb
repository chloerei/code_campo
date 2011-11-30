require 'test_helper'

class ReplyTest < ActiveSupport::TestCase
  test "should set number_id before_create" do
    reply = Factory.build :reply
    assert_nil reply.number_id
    reply.save
    assert_equal 1, reply.number_id
    assert_equal 2, Factory(:reply).number_id

    assert_equal reply, Reply.number(reply.number_id)
  end

  test "should update topic's actived_at column" do
    topic = Factory :topic
    topic.update_attribute :actived_at, 1.hour.ago
    old_time = topic.actived_at
    Factory :reply, :topic => topic
    assert_not_equal old_time.to_i, topic.actived_at.to_i
  end

  test "should inc topic's replies_count column" do
    topic = Factory :topic
    assert_equal 0, topic.replies_count
    assert_difference "topic.reload.replies_count" do
      Factory :reply, :topic => topic
    end
  end

  test "should mark replier to topic" do
    topic = Factory :topic
    user = Factory :user
    Factory :reply, :topic => topic, :user => user
    
    assert topic.reload.replied_by?(user)
  end

  test "should extract mentions" do
    user = Factory :user
    reply = Factory :reply, :content => "@#{user.name}"
    assert_equal [user], reply.mentioned_users

    # 5 mentioned limit
    names = ""
    6.times do
      names << " @#{Factory(:user).name}"
    end
    reply = Factory :reply, :content => names
    assert_equal 5, reply.mentioned_users.count

    # except self
    reply = Factory :reply, :content => "@#{user.name}", :user => user
    assert_equal [], reply.mentioned_users
  end

  test "should reset topic's actived_at after destroy" do
    topic = Factory :topic
    reply = Factory :reply, :topic => topic
    reply_other = Factory :reply, :topic => topic, :created_at => 1.minutes.from_now
    reply_other.destroy
    assert_equal reply.created_at.to_i, topic.actived_at.to_i
  end
end
