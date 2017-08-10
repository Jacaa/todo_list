require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jack)
    log_in_as @user
  end

  test "unsuccessful edit" do
    get edit_user_path(@user)
    assert_template 'users/edit'
    name  = ""
    email = "invalid"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email}}
    assert_template 'users/edit'
  end

  test "successful edit" do
    get edit_user_path(@user)
    assert_template 'users/edit'
    name  = "New Name"
    email = "valid@email.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email}}
    assert_redirected_to root_url
    follow_redirect!
    assert_template 'static_pages/index'
    assert_not flash.empty?
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
end
