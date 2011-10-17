require 'test_helper'

class ResourcesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success, @response.body
  end

  test "should get tagged" do
    resource = Factory :resource, :tags => ['ruby']
    get :tagged, :tag => 'ruby'
    assert_response :success, @response.body
    assert assigns(:resources).include?(resource)
  end

  test "should show resource" do
    resource = Factory :resource
    get :show, :id => resource
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

  test "should vote_up resource" do
    resource = Factory :resource

    put :vote_up, :id => resource
    assert_redirected_to login_url

    user = Factory :user
    login_as user
    assert_difference "resource.reload.up_votes_count" do
      put :vote_up, :id => resource
    end
    assert_redirected_to resource
    assert resource.voted_by?(user)
  end

  test "should unvote_up resource" do
    resource = Factory :resource
    user = Factory :user
    user.vote resource, :up

    delete :unvote_up, :id => resource
    assert_redirected_to login_url

    login_as user
    assert_difference "resource.reload.up_votes_count", -1 do
      delete :unvote_up, :id => resource
    end
    assert_redirected_to resource
    assert !resource.voted_by?(user)
  end
end
