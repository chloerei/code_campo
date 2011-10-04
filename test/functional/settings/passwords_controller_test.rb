require 'test_helper'

class Settings::PasswordsControllerTest < ActionController::TestCase
  def setup
    @password = 'password'
    @user = Factory :user, :password => @password
  end

  test "should get password page" do
    get :show
    assert_redirected_to login_url

    login_as @user
    get :show
    assert_response :success, @response.body
  end

  test "should update password" do
    new_password = 'new password'
    put :update, :user => {:password => new_password, :password_confirmation => new_password, :current_password => @password}
    assert_redirected_to login_url

    login_as @user
    put :update, :user => {:password => new_password, :password_confirmation => new_password, :current_password => @password}
    assert_redirected_to :action => :show
    assert @user.reload.authenticate(new_password)
  end
end
