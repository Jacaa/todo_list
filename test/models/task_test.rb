require 'test_helper'

class TaskTest < ActiveSupport::TestCase

  def setup
    @user = users(:jack)
    @task = @user.tasks.build(content: "Lorem ipsum")
  end

  test "should be valid" do
    assert @task.valid?
  end

  test "user id should be present" do
    @task.user_id = nil
    assert_not @task.valid?
  end

  test "content should be present" do
    @task.content = nil
    assert_not @task.valid?
  end

  test "last task should be shown first" do 
    assert_equal tasks(:last), Task.first
  end

  test "scope done should return tasks with done status true" do
    assert_equal @user.tasks.done.last, tasks(:done_task)
  end

  test "scope todo should return tasks with done status false" do
    assert_equal @user.tasks.todo.last, tasks(:todo_task)
  end
end
