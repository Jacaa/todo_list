require 'test_helper'

class TasksControllerTest < ActionDispatch::IntegrationTest

  def setup
    @task = tasks(:two)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Task.count' do
      post tasks_path, params: { task: { content: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Task.count' do
      delete task_path(@task)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong task" do
    log_in_as(users(:jack))
    task = tasks(:other)
    assert_no_difference 'Task.count' do
      delete task_path(task)
    end
    assert_redirected_to root_url
  end
end
