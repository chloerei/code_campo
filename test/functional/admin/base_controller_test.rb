require 'test_helper'

class Admin::BaseControllerTest < ActionController::TestCase
  def assert_require_admin
    assert !logined?
    yield
    assert_redirected_to login_path
    login_as Factory(:user)
    yield
    assert_redirected_to root_path
    login_as Factory(:user, :email => APP_CONFIG['admin_emails'].first)
    yield
  end
end
