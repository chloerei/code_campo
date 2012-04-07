require 'test_helper'
require 'functional/admin/base_controller_test'

class Admin::DashboardControllerTest < Admin::BaseControllerTest
  def setup
    @topic = create :topic
    @reply = create :reply
    @user = create :user
  end

  test "shoud show dashboard" do
    assert_require_admin do
      get :show
    end
    assert_response :success, @response.body
  end
end
