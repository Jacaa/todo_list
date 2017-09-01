require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    get root_path
    assert_template 'static_pages/index'
  end

  test "signup with account activation" do
    # Signup with invalid params
    assert_no_difference 'User.count' do
      post signup_path, params: { user: {email: "jack@invalid",
                                         password: "password",
                                         password_confirmation: "password"}},
                                         xhr: true
    end
    assert_match "has-error", response.body
    # Sign up with valid params
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: {email: "jack@valid.com",
                                         password: "password",
                                         password_confirmation: "password"}}
    end
    assert_not flash.empty?
    assert_redirected_to root_url
    # Check if email was delivered
    assert_equal 1, ActionMailer::Base.deliveries.size
    # Get the user
    user = assigns(:user)
    assert_not user.activated?
    assert submitted_email_was_saved?
    assert_equal session['last_email'], user.email
    # Try to log in before activation.
    log_in_as(user)
    assert_not user_is_logged_in?
    # Invalid activation token
    get edit_activation_path("invalid token", email: user.email)
    assert_redirected_to root_url
    assert_not user_is_logged_in?
    # Valid token, wrong email
    get edit_activation_path(user.activation_token, email: 'wrong')
    assert_redirected_to root_url
    assert_not user_is_logged_in?
    # Valid activation token
    get edit_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    assert_redirected_to root_url
    follow_redirect!
    assert_template 'static_pages/index'
    assert user_is_logged_in?
  end

  test "signup using oauth" do
    # Signup using github
    assert_difference 'User.count', 1 do
      get '/auth/github/callback'
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    auth = request.env['omniauth.auth']
    assert_equal cookies['user_name'], auth['info']['name']
    assert_equal cookies['user_image'], auth['info']['image']
    assert user_is_logged_in?
    assert_redirected_to root_url
    # Logout
    delete logout_path
    assert_empty cookies['user_name']
    assert_empty cookies['user_image']
    assert_not user_is_logged_in?
    # Login using github - no new record
    assert_no_difference 'User.count' do
      get '/auth/github/callback'
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert user_is_logged_in?
    # Logout
    delete logout_path
    # Try signup with google but with same email as github
    assert_no_difference 'User.count' do
      get '/auth/google_oauth2/callback'
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not user_is_logged_in?
    assert_not flash.empty?
    assert_redirected_to root_path
    # Signup with facebook and other email
    assert_difference 'User.count', 1 do
      get '/auth/facebook/callback'
    end
    assert_equal 2, ActionMailer::Base.deliveries.size
    assert user_is_logged_in?
  end
end
