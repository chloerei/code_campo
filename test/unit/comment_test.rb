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
end
