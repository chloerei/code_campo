require 'test_helper'
require 'functional/admin/base_controller_test'

class Admin::FragmentsControllerTest < Admin::BaseControllerTest
  test "should show fragment setting" do
    assert_require_admin do
      get :index
    end
    assert_response :success, @response.body
  end

  test "should edit fragment" do
    Fragment::FIELDS.each do |field|
      assert_require_admin do
        get :edit, :id => field
      end
      assert_response :success, @response.body
    end
  end

  test "should update fragment" do
    Fragment::FIELDS.each do |field|
      assert_require_admin do
        put :update, :id => field, :fragment => {field => 'some code'}
      end
      assert_redirected_to :action => :edit, :id => field
    end
  end
end
