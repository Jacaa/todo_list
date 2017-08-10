require 'test_helper'

class UsersDestroyTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jack)
  end

  test "should destroy user" do
    log_in_as @user
    assert_difference 'User.count', -1 do
      delete user_path(@user)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end
end
