require 'test_helper'

class PeopleControllerTest < ActionController::TestCase
  def setup
    @user = create :user
  end

  test "should get person page" do
    get :show, :name => @user
    assert_response :success, @response.body
  end
end
