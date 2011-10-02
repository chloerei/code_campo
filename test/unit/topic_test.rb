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

    assert_equal topic, Topic.number(topic.number_id)

    assert_equal topic.number_id.to_s, topic.to_param
  end

  test "should raise if number(number_id) could no found" do
    topic = Factory :topic
    assert_equal topic, Topic.number(topic.number_id)
    assert_equal topic, Topic.find_by_number_id(topic.number_id)

    assert_raise Mongoid::Errors::DocumentNotFound do
      Topic.number -1
    end
    assert_nil Topic.find_by_number_id(-1)
  end

  test "should maintain tags_string" do
    topic = Factory :topic, :tags => nil
    topic.tags_string = "ruby programing"
    assert_equal ["ruby", "programing"].sort, topic.tags.sort
    topic.tags_string = "ruby,programing"
    assert_equal ["ruby", "programing"].sort, topic.tags.sort
  end
end
