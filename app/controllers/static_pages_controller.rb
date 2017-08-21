class StaticPagesController < ApplicationController
  
  def index
    if logged_in?
      @user  = current_user
      @todo_tasks = @user.tasks.todo
      @todo_count = @user.tasks.todo.count
      @done_tasks = @user.tasks.done
      @done_count = @user.tasks.done.count
      @task  = @user.tasks.build
    end
  end
end
