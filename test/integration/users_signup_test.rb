require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "valid signup with account activation" do
    # Sign up with valid params
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: {name: "Jack",
                                         email: "jack@valid.com",
                                         password: "password",
                                         password_confirmation: "password"}}
    end
    # Check if email was delivered
    assert_equal 1, ActionMailer::Base.deliveries.size
    # Get the user
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation.
    log_in_as(user)
    assert_not user_is_logged_in?
    # Invalid activation token
    get edit_activation_path("invalid token", email: user.email)
    assert_not user_is_logged_in?
    # Valid token, wrong email
    get edit_activation_path(user.activation_token, email: 'wrong')
    assert_not user_is_logged_in?
    # Valid activation token
    get edit_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'static_pages/index'
    assert user_is_logged_in?
  end

  test "invalid signup" do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { user: {name: "Jack",
                                         email: "jack@invalid",
                                         password: "password",
                                         password_confirmation: "pass"}}
    end
    assert_template 'users/new'
    assert_select "div#error-explanation"
  end
end
