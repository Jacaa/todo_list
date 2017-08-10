require 'test_helper'

class TasksInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jack)
    log_in_as @user
  end

  test "tasks interface" do
    log_in_as @user
    get root_path
    assert_template 'static_pages/index'
    # Invalid task
    assert_no_difference 'Task.count' do
      post tasks_path, params: { task: { content: "" } }
    end
    assert_not flash.empty?
    assert_redirected_to root_url
    # Valid task
    content = "Lorem ipsum"
    assert_no_match content, response.body
    assert_difference 'Task.count', 1 do
      post tasks_path, params: { task: { content: content } }
    end
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # Delete task
    assert_select 'a', text: 'delete'
    task = @user.tasks.first
    assert_match task.content, response.body
    assert_difference 'Task.count', -1 do
      delete task_path(task)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end
end
