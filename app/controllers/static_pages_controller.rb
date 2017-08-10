class StaticPagesController < ApplicationController
  
  def index
    if logged_in?
      @user  = current_user
      @tasks = @user.tasks
      @task  = @user.tasks.build
    end
  end
end
