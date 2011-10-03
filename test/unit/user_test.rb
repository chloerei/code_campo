require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should have password" do
    password = '123456'
    user = Factory :user, :password => password, :password_confirmation => password
    assert_not_nil user.password_digest
    assert user.authenticate(password)
    assert !user.authenticate(password + 'wrong')
  end

  test "should generate remember token" do
    user = Factory :user
    assert_not_nil user.remember_token
    token = user.remember_token
    assert_equal user, User.find_by_remember_token(token)

    user.update_attributes :password => 'change', :password_confirmation => 'change'
    assert_not_equal token, user.remember_token
    assert_nil User.find_by_remember_token(token)
  end
end
