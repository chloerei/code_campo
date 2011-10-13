require 'test_helper'

class ResourceTest < ActiveSupport::TestCase
  test "should get domain by url" do
    resource = Factory :resource, :url => 'http://codecampo.com/topics/1'
    assert_equal 'codecampo.com', resource.host
  end
end
