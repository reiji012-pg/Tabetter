require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @base_title = "Tabetter"
    @user = users(:user1)
  end
  
  test "should get new" do
    get login_path
    assert_response :success
    assert_select "title", "Log in | #{@base_title}"
  end

end
