require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should have password" do
    password = '123456'
    user = Factory :user, :password => password, :password_confirmation => password
    assert_not_nil user.password_digest
    assert user.authenticate(password)
    assert !user.authenticate(password + 'wrong')
  end
end
