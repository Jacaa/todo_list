require 'test_helper'

class TasksControllerTest < ActionDispatch::IntegrationTest

  def setup
    @task = tasks(:todo_task)
    @other_user_task = tasks(:other)
  end

  # Create action
  test "should redirect create when not logged in" do
    assert_no_difference 'Task.count' do
      post tasks_path, params: { task: { content: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end
  
  # Destroy action
  test "should redirect destroy when not logged in" do
    assert_no_difference 'Task.count' do
      delete task_path(@task)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong task" do
    log_in_as(users(:jack))
    assert_no_difference 'Task.count' do
      delete task_path(@other_user_task)
    end
    assert_redirected_to root_url
  end
  
  # Change action
  test "should redirect change when not logged in" do
    get change_task_path(@task)
    assert_not @task.reload.done?
    assert_redirected_to login_url
  end

  test "should redirect change for wrong task" do
    log_in_as(users(:jack))
    get change_task_path(@other_user_task)
    assert_not @task.reload.done?
    assert_redirected_to root_url
  end

  # Edit action
  test "should redirect edit when not logged in" do
   get edit_task_path(@task)
   assert_redirected_to login_url
  end

  test "should redirect edit for wrong user" do
    log_in_as(users(:jack))
    get edit_task_path(@other_user_task)
    assert_redirected_to root_url
  end

  # Update action
  test "should redirect update when not logged in" do
    patch task_path(@task), params: { task: { content: "new content" } }
    assert_match @task.content, @task.reload.content
    assert_redirected_to login_url
  end

  test "should redirect update for wrong user" do
    log_in_as(users(:jack))
    patch task_path(@other_user_task), params: { task: {content: "new content"}}
    assert_match @other_user_task.content, @other_user_task.reload.content
    assert_redirected_to root_url
  end
end
