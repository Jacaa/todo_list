require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:jack)
  end

  test "current_user returns right user when the session is not nil" do
    log_in @user
    assert_not_nil current_user
  end

  test "current_user returns nil when session is nil and user is not remembered" do
    log_out
    assert_nil current_user
  end

  test "current_user returns right user when session is nil" do
    remember(@user)
    assert_equal @user, current_user
    assert user_is_logged_in?
  end

  test "current_user returns nil when remember token is wrong" do
    remember(@user)
    @user.update_attribute(:remember_token, User.new_token)
    assert_nil current_user
  end
end