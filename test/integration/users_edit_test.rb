require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:user1)
    @other_user = users(:user2)
  end
  
  test "unsuccessful update" do
    log_in_as(@user)
    get edit_user_path(@user)
    patch user_path(@user), params: { user: { name: "",
                                              email: "user@example",
                                              password:              "pass",
                                              password_confirmation: "word" } }
    assert_template 'users/edit'
    assert_match "4 errors", response.body
    assert_select "div.field_with_errors"
  end
  
  test "successful update when logged as correct user" do
    name = "test"
    email = "test@example.com"
    user_params = { user: { name: name, email: email,
                            password:              "",
                            password_confirmation: "" } }
    # login前にupdateして失敗
    patch user_path(@user), params: user_params
    assert_not flash.empty?
    assert_redirected_to login_url
    # login後に別ユーザーにupdateして失敗
    log_in_as(@user)
    patch user_path(@other_user), params: user_params
    assert_not flash.empty?
    assert_redirected_to root_url
    # loginユーザーにupdateして成功
    patch user_path(@user), params: user_params
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
  
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    assert_nil session[:forwarding_url]
  end
  
end
