require 'test_helper'

class UsersInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jack)
    log_in_as @user
  end

  test "edit user" do
    get edit_user_path(@user)
    assert_template 'users/edit'
    # Unsuccesfull edit
    name  = ""
    email = "invalid"
    patch user_path(@user), params: { user: { name:  name, email: email}}
    assert_template 'users/edit'
    assert_select 'div#error-explanation'
    # Successfull edit
    name  = "New Name"
    email = "valid@email.com"
    patch user_path(@user), params: { user: { name:  name, email: email}}
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_template 'static_pages/index'
  end

  test "destroy user" do
    get edit_user_path(@user)
    assert_template 'users/edit'
    assert_select 'a', text: 'Delete profile'
    assert_difference 'User.count', -1 do
      delete user_path(@user)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end
end
