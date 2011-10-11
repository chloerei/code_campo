require 'test_helper'

class ResourcesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success, @response.body
  end

  test "should get new page" do
    get :new
    assert_redirected_to login_url

    login_as Factory(:user)
    get :new
    assert_response :success, @response.body
  end

  test "should create resource" do
    post :create, :resource => Factory.attributes_for(:resource)
    assert_redirected_to login_url

    login_as Factory(:user)
    assert_difference "Resource.count" do
      post :create, :resource => Factory.attributes_for(:resource)
    end
    assert_redirected_to resource_path(Resource.last)
  end
end
