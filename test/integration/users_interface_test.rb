require 'test_helper'

class UsersInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:jack)
  end

  test "edit user" do
    log_in_as @user
    get edit_user_path(@user)
    assert_template 'users/edit'
    # Unsuccesfull email edit
    email = "invalid"
    patch user_path(@user), params: { user: { email: email}}
    assert_template 'users/edit'
    assert_select '.has-error'
    # Successfull email edit
    old_email = @user.email
    new_email = "valid@email.com"
    patch user_path(@user), params: { user: { email: new_email}}
    @user.reload
    assert_equal new_email, @user.email
    assert_not @user.activated?
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert submitted_email_was_saved?
    assert_equal session[:last_email], @user.email
    assert_not flash.empty?
    assert_redirected_to root_url
    # Try click activation link with old email
    get edit_activation_path(@user.activation_token, email: old_email)
    assert_not flash.empty?
    assert_redirected_to root_url
    assert_not user_is_logged_in?
    # Get activation link with new email
    get edit_activation_path(@user.activation_token, email: new_email)
    assert @user.reload.activated?
    assert user_is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_template 'static_pages/index'
  end

  test "destroy user" do
    log_in_as @user
    get edit_user_path(@user)
    assert_template 'users/edit'
    assert_select 'a', text: 'Delete profile'
    assert_difference 'User.count', -1 do
      delete user_path(@user)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "send activation link again" do
    @user.toggle!(:activated)
    log_in_as @user
    assert submitted_email_was_saved?
    assert_equal session[:last_email], @user.email
    post activations_path
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
  end
end
