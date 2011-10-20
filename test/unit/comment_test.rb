require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test "should update resource's comments_count" do
    resource = Factory :resource
    assert_equal 0, resource.comments_count
    assert_difference "resource.reload.comments_count" do
      Factory :comment, :resource => resource
    end
  end
end
