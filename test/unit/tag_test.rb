require 'test_helper'

class TagTest < ActiveSupport::TestCase
  test "should recount tags" do
    create :topic, :tags => ['one']
    create :topic, :tags => ['one', 'two']
    create :topic, :tags => ['one', 'two', 'three']
    Tag.recount
    assert_equal 3, Tag.count
    assert_equal 3, Tag.find('one').value
    assert_equal 2, Tag.find('two').value
    assert_equal 1, Tag.find('three').value
  end
end
