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

  test "change email, password need current_password" do
    password = '123456'
    user = Factory :user, :password => password, :password_confirmation => password
    user.name = 'change_name'
    assert !user.save
    assert user.errors[:current_password].any?
    user.current_password = 'wrong password'
    assert !user.save
    assert user.errors[:current_password].any?
    user.current_password = password
    assert user.save
  end

  test "should have access_token, and find user by access_token" do
    user = Factory :user
    assert_not_nil user.access_token
    assert_equal user, User.find_by_access_token(user.access_token)
    
    old_token = user.access_token
    user.reset_access_token
    assert_not_equal old_token, user.access_token
    assert_equal user, User.find_by_access_token(user.access_token)

    assert_equal nil, User.find_by_access_token(nil)
  end

  test "admin logic by Setings admin emails" do
    assert !Factory(:user).admin?
    assert Factory(:user, :email => APP_CONFIG['admin_emails'].first).admin?
  end
end
