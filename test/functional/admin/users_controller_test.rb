require 'test_helper'
require 'functional/admin/base_controller_test'

class Admin::UsersControllerTest < Admin::BaseControllerTest
  def setup
    @user = create :user
  end

  test "should get index" do
    assert_require_admin do
      get :index
    end
    assert_response :success, @response.body
  end

  test "should show user" do
    assert_require_admin do
      get :show, :id => @user
    end
    assert_response :success, @response.body
  end

  test "should destroy user" do
    assert_require_admin do
      delete :destroy, :id => @user
    end
    assert_nil User.where(:_id => @user.id).first
    assert_redirected_to :action => :index
  end
end
