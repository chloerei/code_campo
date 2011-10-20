require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  def setup
    @resource = Factory :resource
    @user = Factory :user
    @parent = Factory :comment
  end

  test "should get new page" do
    get :new, :resource_id => @resource
    assert_redirected_to login_url
    
    login_as @user
    get :new, :resource_id => @resource
    assert_response :success, @response.body

    get :new, :resource_id => @resource, :parent_id => @parent
    assert_response :success, @response.body
  end

  test "should create comment" do
    post :create, :resource_id => @resource, :comment => {:content => 'content'}
    assert_redirected_to login_url

    login_as @user
    assert_difference "@resource.comments.count" do
      post :create, :resource_id => @resource, :comment => {:content => 'content'}
    end

    assert_difference "@resource.comments.count" do
      assert_difference "@parent.children.count" do
        post :create, :resource_id => @resource, :parent_id => @parent, :comment => {:content => 'content'}
      end
    end
  end
end
