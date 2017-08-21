require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test "index page layout when user is not logged in" do
    get root_path
    assert_template 'static_pages/index'
    assert_select "title", "ToDo"
    assert_select "a[href=?]", signup_path
    assert_select "a[href=?]", root_path
    assert_select "input[type=email]",    count: 1
    assert_select "input[type=password]", count: 1
    assert_select "input[type=checkbox]", count: 1
    assert_select "input[type=submit]",   count: 1
    assert_select "a[href=?]", new_password_reset_path
  end

  test "index page layout when user is logged in" do
    user = users(:jack)
    log_in_as(user)
    get root_path
    assert_template 'static_pages/index'
    assert_select 'a[href=?]', edit_user_path(user)
    assert_select 'a[href=?]', logout_path
    assert_select 'textarea'
    assert_select "input[type=submit]", count: 1
  end

  test "index page layout when user is logged in and has todo tasks" do
    user = users(:jack)
    log_in_as(user)
    get root_path
    assert_select "span.glyphicon-remove", count: user.tasks.count
    user.tasks.each do |task|
      assert_match task.content, response.body
    end
  end

  test "index page layout when user is logged in and hasn't todo tasks" do
    user = users(:user_no_tasks)
    log_in_as(user)
    get root_path
    assert_select 'h3.no-todo-tasks'
  end

  test "signup page layout" do
    get signup_path
    assert_template 'users/new'
    assert_select "a[href=?]", root_path
    assert_select "input[type=email]",    count: 1
    assert_select "input[type=text]",     count: 1
    assert_select "input[type=password]", count: 2
    assert_select "input[type=submit]",   count: 1
  end

  test "new password-reset page layout" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    assert_select "input[type=email]",  count: 1
    assert_select "input[type=submit]", count: 1
  end

  test "edit password-reset page layout" do
    user = users(:jack)
    user.update_attributes(password_reset_sent_at: Time.zone.now,
                           password_reset_token:   User.new_token)
    get edit_password_reset_path(user.password_reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[type=password]", count: 2
    assert_select "input[type=submit]",   count: 1
  end
end
