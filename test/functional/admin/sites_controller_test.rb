require 'test_helper'
require 'functional/admin/base_controller_test'

class Admin::SitesControllerTest < Admin::BaseControllerTest
  test "should show site settings" do
    assert_require_admin do
      get :show
    end
    assert_response :success, @response.body
  end

  test "should update site settings" do
    assert_require_admin do
      put :update, :site => {:name => 'change'}
    end
    assert_redirected_to :action => :show
    assert_equal 'change', Site.first.name
  end
end
