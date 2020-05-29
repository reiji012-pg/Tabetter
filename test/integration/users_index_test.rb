require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:Admin)
    @other_user = users(:user1)
  end
  
  test "index including pagination" do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select "div.pagination", count: 2
    User.paginate(page: 1).each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
      unless user == @user
        assert_select "a[href=?]", user_path(user), text: "delete"
      end
    end
    assert_difference "User.count", -1 do
      delete user_path(@other_user)
    end
    assert_not flash.empty?
    assert_redirected_to users_url
  end
  
  test "index as non_admin" do
    log_in_as(@other_user)
    get users_path
    assert_select "a", text: "delete", count: 0
  end
end
