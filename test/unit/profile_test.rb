require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  test "should have profile after create user" do
    user = Factory :user
    assert_not_nil user.profile
  end
end
