require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  test "should init actived_at column" do
    assert_not_nil Factory(:topic).actived_at
  end

  test "should set number_id before_create" do
    topic = Factory.build :topic
    assert_nil topic.number_id
    topic.save
    assert_equal 1, topic.number_id
    assert_equal 2, Factory(:topic).number_id

    assert_equal topic, Topic.find_by_number_id(topic.number_id)
  end
end
