require 'test_helper'

class Settings::ProfilesControllerTest < ActionController::TestCase
  def setup
    @user = create :user
  end

  test "should get profile page" do
    get :show
    assert_redirected_to login_url

    login_as @user
    get :show
    assert_response :success, @response.body
  end

  test "should update profile" do
    put :update, :name => 'new name'
    assert_redirected_to login_url

    login_as @user
    put :update, :name => 'new name'
    assert_redirected_to :action => :show
  end
end
