require 'test_helper'
require 'functional/admin/base_controller_test'

class Admin::TopicsControllerTest < Admin::BaseControllerTest
  def setup
    @topic = create :topic
  end

  test "should get index" do
    assert_require_admin do
      get :index
    end
    assert_response :success, @response.body
  end

  test "should show topic" do
    assert_require_admin do
      get :show, :id => @topic
    end
    assert_response :success, @response.body
  end

  test "should destroy topic" do
    assert_difference "Topic.count", -1 do
      assert_require_admin do
        delete :destroy, :id => @topic
      end
    end
    assert_redirected_to :action => :index
  end
end
