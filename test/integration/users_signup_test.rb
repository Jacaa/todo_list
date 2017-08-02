require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "valid signup" do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: {name: "Johny",
                                         email: "johny@valid.com",
                                         password: "password",
                                         password_confirmation: "password"}}
    end
    follow_redirect!
    assert_template 'static_pages/index'
    assert_not flash.empty?
    assert_select "div.alert-success"
  end

  test "invalid signup" do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { user: {name: "Johny",
                                         email: "johny@invalid",
                                         password: "password",
                                         password_confirmation: "pass"}}
    end
    assert_template 'users/new'
    # Invalid email and password_confirmation doesn't match password
    assert_select "div#error-explanation"
    assert_select "li", count: 2 
  end
end
