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
end
