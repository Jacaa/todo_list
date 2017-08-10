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

  test "order should be last task first" do 
    assert_equal tasks(:last), Task.first
  end
end
