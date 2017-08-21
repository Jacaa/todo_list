require 'test_helper'

class TasksInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jack)
    log_in_as @user
  end
  
  test "create task" do
    get root_path
    assert_template 'static_pages/index'
    # Invalid submission
    content = ""
    assert_no_difference 'Task.count' do
      post tasks_path, params: { task: { content: content } }
    end
    assert_redirected_to root_url
    # Valid submission
    content = "Lorem ipsum"
    assert_no_match content, response.body
    assert_difference 'Task.count', 1 do
      post tasks_path, params: { task: { content: content } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
  end

  test "destroy task" do
    get root_path
    assert_template 'static_pages/index'
    assert_select 'span.glyphicon-remove'
    task = @user.tasks.first
    assert_match task.content, response.body
    assert_difference 'Task.count', -1 do
      delete task_path(task)
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_no_match task.content, response.body
  end

  test "change task status" do
    get root_path
    assert_template 'static_pages/index'
    assert_select 'span.glyphicon-ok'
    task = tasks(:todo_task)
    assert_not task.done?
    # Change task's status to true - done
    get change_task_path(task)
    assert task.reload.done?
    assert_redirected_to root_url
  end
end
