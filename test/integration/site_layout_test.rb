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
