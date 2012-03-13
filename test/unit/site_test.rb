require 'test_helper'

class SiteTest < ActiveSupport::TestCase
  test "should build with fragment" do
    site = Factory :site
    assert_not_nil site.fragment
  end
end
