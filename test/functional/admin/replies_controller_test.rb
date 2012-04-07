require 'test_helper'
require 'functional/admin/base_controller_test'

class Admin::RepliesControllerTest < Admin::BaseControllerTest
  def setup
    @reply = create :reply
  end

  test "should get index" do
    assert_require_admin do
      get :index
    end
    assert_response :success, @response.body
  end

  test "should show reply" do
    assert_require_admin do
      get :show, :id => @reply
    end
    assert_response :success, @response.body
  end

  test "should destroy topic" do
    assert_difference "Reply.count", -1 do
      assert_require_admin do
        delete :destroy, :id => @reply
      end
    end
    assert_redirected_to :action => :index
  end
end
