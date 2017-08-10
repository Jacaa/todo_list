require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test "index page layout" do
    get root_path
    assert_template 'static_pages/index'
    assert_select "title", "ToDo"
    assert_select "a", count: 3
    assert_select "a[target=_blank]", "GitHub"
    assert_select "a[href=?]", signup_path
    assert_select "a[href=?]", login_path
  end

  test "index page layout when logged in" do
    user = users(:jack)
    log_in_as(user)
    get root_path
    assert_template 'static_pages/index'
    assert_select 'a[href=?]', edit_user_path(user)
    assert_select 'a[href=?]', logout_path
    assert_select 'textarea'
    user.tasks.each do |task|
      assert_match task.content, response.body
    end
    assert_select 'a', text: 'delete', count: user.tasks.count
  end

  test "signup page layout" do
    get signup_path
    assert_template 'users/new'
    assert_select "a[href=?]", root_path
    assert_select "input[type=submit]", count: 1
  end

  test "login page layout" do
    get login_path
    assert_template 'sessions/new'
    assert_select "a[href=?]", root_path
    assert_select "input[type=submit]", count: 1
    assert_select "input[type=checkbox]", count: 1
  end
end
