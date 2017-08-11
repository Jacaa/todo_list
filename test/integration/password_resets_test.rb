require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:jack)
  end
  
  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Invalid email
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # Valid email
    post password_resets_path, params: { password_reset: { email: @user.email }}
    assert_not_equal @user.password_reset_token, @user.reload.password_reset_token
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # Password reset form
    user = assigns(:user)
    # Wrong email
    get edit_password_reset_path(user.password_reset_token, email: "")
    assert_redirected_to root_url
    # Inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.password_reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    # Right email, wrong token
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    # Right email, right token
    get edit_password_reset_path(user.password_reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
    # Invalid password & confirmation
    change_password(user, "foobar", "barfoo")
    assert_select 'div#error-explanation'
    # Empty password
    change_password(user, "", "")
    assert_select 'div#error-explanation'
    # Valid password & confirmation
    change_password(user, "foobar", "foobar")
    assert user_is_logged_in?
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "expired token" do
    get new_password_reset_path
    post password_resets_path, params: { password_reset: { email: @user.email }}

    @user = assigns(:user)
    @user.update_attribute(:password_reset_sent_at, 3.hours.ago)
    change_password(@user, "foobar", "foobar")
    assert_redirected_to new_password_reset_path
    follow_redirect!
    assert_not flash.empty?
  end
end
