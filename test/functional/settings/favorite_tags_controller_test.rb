require 'test_helper'

class Settings::FavoriteTagsControllerTest < ActionController::TestCase
  def setup
    @user = Factory :user
  end

  test "should get favorite tags page" do
    get :index
    assert_redirected_to login_url

    login_as @user
    get :index
    assert_response :success, @response.body
  end

  test "should add favorite tags" do
    post :create, :user => {:extra_favorite_tag_string => 'ruby programing'}
    assert_redirected_to login_url
    
    login_as @user
    post :create, :user => {:extra_favorite_tag_string => 'ruby programing'}
    assert_equal %w(ruby programing).sort, current_user.favorite_tags.sort
  end

  test "should destroy favorite tag" do
    delete :destroy, :id => 'ruby'
    assert_redirected_to login_url
    
    login_as Factory(:user, :favorite_tags => %w(ruby))
    delete :destroy, :id => 'ruby'
    assert_redirected_to :action => :index
    assert_equal [], current_user.favorite_tags
  end
end
