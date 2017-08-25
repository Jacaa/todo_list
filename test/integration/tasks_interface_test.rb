require 'test_helper'

class TasksInterfaceTest < ActionDispatch::IntegrationTest

  test "task flow" do
    log_in_as users(:user_no_tasks)
    # Invalid submission
    content = ""
    assert_no_difference 'Task.count' do
      post tasks_path, params: { task: { content: content } }, xhr: true
    end
    # Valid submission
    content = "New task"
    assert_difference 'Task.count', 1 do
      post tasks_path, params: { task: { content: content } }, xhr: true
    end
    assert_match content, response.body
    task = assigns(:task)
    # Check task layout
    get root_path
    assert_select 'span.glyphicon-ok'
    assert_select 'span.glyphicon-pencil'
    assert_select 'span.glyphicon-remove'
    # Change task status to done
    get change_task_path(task), xhr: true
    assert task.reload.done?
    # Change task status again - todo
    get root_path
    assert_select 'span.glyphicon-repeat'
    get change_task_path(task), xhr: true
    assert_not task.reload.done?
    # Edit task
    get edit_task_path(task), xhr: true
    assert_match "edit_task", response.body
    new_content = 'new content'
    patch task_path(task), params: { task: { content: new_content } }, xhr: true
    assert_equal new_content, task.reload.content
    assert_match new_content, response.body
    # Destroy task
    assert_difference 'Task.count', -1 do
      delete task_path(task), xhr: true
    end
  end
end
