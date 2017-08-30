require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

OmniAuth.config.test_mode = true
omniauth_hash = { 'provider' => 'github',
                  'uid' => '12345',
                  'info' => {
                      'name' => 'jack',
                      'email' => 'jack@github.com'
                  }
                }

OmniAuth.config.add_mock(:github, omniauth_hash)

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def user_is_logged_in?
    !session[:user_id].nil?
  end

  def submitted_email_was_saved?
    !session[:last_email].nil?
  end
end

class ActionDispatch::IntegrationTest

  def log_in_as(user, password: 'password', remember_me: '1' )
    post login_path, params: { session: { email: user.email, 
                                          password: password,
                                          remember_me: remember_me}}
  end
  
  # Used by password reset integration test
  def change_password(user, password, password_confirmation)
    patch password_reset_path(user.password_reset_token),
          params: { email: user.email,
                    user: { password:              password,
                            password_confirmation: password_confirmation } }
  end
end
