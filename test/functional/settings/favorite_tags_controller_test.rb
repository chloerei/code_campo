require 'test_helper'

class Settings::FavoriteTagsControllerTest < ActionController::TestCase
  def setup
    @user = Factory :user
  end

  test "should get favorite tags page" do
    get :show
    assert_redirected_to login_url

    login_as @user
    get :show
    assert_response :success, @response.body
  end

  test "should add favorite tags" do
    post :update, :user => {:extra_favorite_tag_string => 'ruby programing'}
    assert_redirected_to login_url
    
    login_as @user
    post :update, :user => {:extra_favorite_tag_string => 'ruby programing'}
    assert_equal %w(ruby programing).sort, current_user.favorite_tags.sort
  end
end
