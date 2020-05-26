require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @base_title = "Tabetter"
    @user = users(:user1)
  end
  
  test "should get show" do
    get user_path(@user)
    assert_response :success
    assert_select "title", "#{@user.name} | #{@base_title}"
    assert_select "h2", @user.name
  end

  test "should get new" do
    get signup_path
    assert_response :success
    assert_select "title", "登録 | #{@base_title}"
  end

end
