require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid signup information" do
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: "",
                                         email: "user@example",
                                         password:              "pass",
                                         password_confirmation: "word" } }
    end
    assert_template 'users/new'
    assert_match "4 errors", response.body
    assert_select "div.field_with_errors"
    assert_select "form[action=?]", "/signup"
  end
  
  test "valid signup information" do
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name: "user",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template "users/show"
    assert_not flash.empty?
    assert is_logged_in?
  end
end
