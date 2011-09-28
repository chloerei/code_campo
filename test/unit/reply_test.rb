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
end
