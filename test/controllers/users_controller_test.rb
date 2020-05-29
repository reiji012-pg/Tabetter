require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @base_title = "Tabetter"
    @user = users(:Admin)
    @other_user = users(:user2)
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

  test "should get edit when logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
    log_in_as(@user)
    get edit_user_path(@user)
    assert_response :success
    assert_select "title", "更新 | #{@base_title}"
  end
  
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect index when not logged in" do
    get users_path
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: { 
                                  user: { password: "",
                                          password_confirmation: "",
                                          admin: true } }
    assert_not @other_user.reload.admin?
  end
  
  test "should redirect destroy when not logged in" do
    assert_no_difference "User.count" do
      delete user_path(@user)
    end
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect destroy when logged in as a non_admin" do
    log_in_as(@other_user)
    assert_no_difference "User.count" do
      delete user_path(@user)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect destroy when self delete" do
    log_in_as(@user)
    assert_no_difference "User.count" do
      delete user_path(@user)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end
    
end
