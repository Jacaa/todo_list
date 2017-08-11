require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jack)
  end

  test "login with valid information followed by logout" do
    # Log in
    log_in_as @user
    assert user_is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_template 'static_pages/index'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_match @user.name, response.body
    # Log out
    delete logout_path
    assert_redirected_to root_url
    follow_redirect!
    assert_template 'static_pages/index'
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_no_match @user.name, response.body
  end

  test "login with invalid information" do
    log_in_as(@user, password: " ")
    assert_template 'sessions/new'
    assert_not flash.empty?
  end

  test "remember me" do
    # Log in with remembering
    log_in_as(@user, remember_me: '1')
    assert_not_empty cookies['remember_token']
    assert_not_empty cookies['user_id']
    # Log out
    delete logout_path
    assert_empty cookies['remember_token']
    assert_empty cookies['user_id']
    # Log in again without remembering
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
    assert_empty cookies['user_id']
  end
end
