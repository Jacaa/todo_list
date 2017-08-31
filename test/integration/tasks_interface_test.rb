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
    assert_select '#todo_count', text: '1'
    assert_select '#done_count', text: '0'
    assert_select 'span.glyphicon-ok'
    assert_select 'span.glyphicon-pencil'
    assert_select 'span.glyphicon-remove'
    # Change task status to done
    get change_task_path(task), xhr: true
    assert task.reload.done?
    get root_path
    assert_select '#todo_count', text: '0'
    assert_select '#done_count', text: '1'
    assert_select 'span.glyphicon-repeat'
    # Change task status again - todo
    get change_task_path(task), xhr: true
    assert_not task.reload.done?
    get root_path
    assert_select '#todo_count', text: '1'
    assert_select '#done_count', text: '0'
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
    get root_path
    assert_select '#todo_count', text: '0'
  end

  test "delete all tasks" do
    user = users(:jack)
    log_in_as user
    # Delete done tasks
    assert_difference 'Task.count', -user.tasks.done.count do
      delete delete_all_task_path(user, done: true)
    end
    assert_redirected_to root_path
    # Delete todo tasks
    assert_difference 'Task.count', -user.tasks.todo.count do
      delete delete_all_task_path(user, done: false)
    end
    assert_redirected_to root_path
  end
end
