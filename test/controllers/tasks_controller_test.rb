require 'test_helper'

class TasksControllerTest < ActionDispatch::IntegrationTest

  # Create action
  test "should redirect create when not logged in" do
    assert_no_difference 'Task.count' do
      post tasks_path, params: { task: { content: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end
  
  # Destroy action
  test "should redirect destroy when not logged in" do
    task = tasks(:two)
    assert_no_difference 'Task.count' do
      delete task_path(task)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong task" do
    user = users(:jack)
    log_in_as(user)
    task = tasks(:other)
    assert_no_difference 'Task.count' do
      delete task_path(task)
    end
    assert_redirected_to root_url
  end

  # Change action
  test "should redirect change when not logged in" do
    task = tasks(:two)
    get change_task_path(task)
    assert_not task.reload.done?
    assert_redirected_to login_url
  end

  test "should redirect change for wrong task" do
    user = users(:jack)
    log_in_as(user)
    task = tasks(:other)
    get change_task_path(task)
    assert_not task.reload.done?
    assert_redirected_to root_url
  end
end
