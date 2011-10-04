require 'test_helper'

class Settings::AccountsControllerTest < ActionController::TestCase
  def setup
    @password = 'password'
    @user = Factory :user, :password => @password
  end

  test "should show account page" do
    get :show
    assert_redirected_to login_url

    login_as @user
    get :show
    assert_response :success, @response.body
  end

  test "should update account settings" do
    put :update, :user => {:name => 'change', :current_password => @password}
    assert_redirected_to login_url
    
    login_as @user
    put :update, :user => {:name => 'change', :current_password => @password}
    assert_redirected_to :action => :show
    assert_equal 'change', @user.reload.name
  end
end
