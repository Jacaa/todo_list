require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jack)
  end

  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email: @user.email, 
                                          password: 'password'}}
    assert user_is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_template 'static_pages/index'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "h5", text: @user.name
    delete logout_path
    follow_redirect!
    assert_template 'static_pages/index'
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "h5", text: @user.name, count: 0
    
  end

  test "login with invalid information" do
    get login_path
    post login_path, params: { session: { email: "invalid", password: " "}}
    assert_template 'sessions/new'
    assert_not flash.empty?
  end
end
