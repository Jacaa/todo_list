require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test "index page layout when user is not logged in" do
    get root_path
    assert_template 'static_pages/index'
    assert_select "title", "ToDo"
    assert_select "a[href=?]", activations_path
    assert_select "a[href=?]", "#signupModal"
    assert_select "a[href=?]", root_path
    assert_select "input[id=session_email]",       count: 1
    assert_select "input[id=session_password]",    count: 1
    assert_select "input[id=session_remember_me]", count: 1
    assert_select "input[value='Login']",          count: 1
    assert_select "a[href=?]", new_password_reset_path
    # Signup form modal
    assert_select "#signupModal"
    assert_select "input[id=user_email]",                    count: 1
    assert_select "input[id=user_password]",                 count: 1
    assert_select "input[id=user_password_confirmation]",    count: 1
    assert_select "input[value='Create my account']",        count: 1
  end

  test "index page layout when user is logged in" do
    user = users(:jack)
    log_in_as(user)
    get root_path
    assert_template 'static_pages/index'
    assert_select 'a[href=?]', edit_user_path(user)
    assert_select 'a[href=?]', logout_path
    assert_select 'textarea[id=task_content]', count: 1
    assert_select "input[value='Add']",        count: 1
  end

  test "index page layout when user is logged in and has todo tasks" do
    user = users(:jack)
    log_in_as(user)
    get root_path
    assert_select "span.glyphicon-ok", count: user.tasks.todo.count
    user.tasks.todo.each do |task|
      assert_match task.content, response.body
    end
  end

  test "index page layout when user is logged in and hasn't todo tasks" do
    log_in_as(users(:user_no_tasks))
    get root_path
    assert_select '#no-tasks'
  end

  test "index page layout when user is logged in and has done tasks" do
    user = users(:jack)
    log_in_as(user)
    get root_path
    assert_select "span.glyphicon-repeat", count: user.tasks.done.count
    user.tasks.done.each do |task|
      assert_match task.content, response.body
    end
  end

  test "new password-reset page layout" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    assert_select "input[id=password_reset_email]",  count: 1
    assert_select "input[value='OK!']",       count: 1
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
