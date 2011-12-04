require 'test_helper'

class MentionableTest < ActiveSupport::TestCase
  class TestModel
    include Mongoid::Document
    include Mentionable

    belongs_to :user
    field :content
  end

  test "should had mention user field" do
    object = TestModel.new
    assert object.respond_to? :mentioned_users
  end

  test "should extract mention users" do
    user = Factory :user
    object = TestModel.create :content => "@#{user.name}", :user => Factory(:user)
    assert_equal [user], object.mentioned_users.to_a

    # 5 mentioned limit
    names = ""
    6.times do
      names << " @#{Factory(:user).name}"
    end
    object = TestModel.create :content => names, :user => Factory(:user)
    assert_equal 5, object.mentioned_users.count

    # except self
    object = TestModel.create :content => "@#{user.name}", :user => user
    assert_equal 0, object.mentioned_users.count
  end

  test "should send mention notification after create" do
    user = Factory :user
    assert_difference "user.notifications.unread.count" do
      object = TestModel.create :content => "@#{user.name}", :user => Factory(:user)
    end
  end
end
