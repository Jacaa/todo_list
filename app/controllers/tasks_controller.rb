class TasksController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:destroy, :change, :edit, :update]

  def create
    @task = current_user.tasks.build(task_params)
    puts @task.id
    respond_to do |format|
      if @task.save
        count_tasks
        format.js
      else 
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def delete_all
    @user = User.find(params[:id])
    Task.where(user_id: @user.id).where(done: params[:done]).delete_all
    redirect_to root_url
  end

  def destroy
    @task.destroy
    count_tasks
    respond_to :js
  end

  def change
    @task.change_status
    count_tasks
    respond_to :js
  end
 
  def edit
    respond_to :js
  end

  def update
    respond_to do |format|
      if @task.update_attributes(task_params)
        format.js
      else 
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def task_params
      params.require(:task).permit(:content)
    end

    def correct_user
      @task = current_user.tasks.find_by(id: params[:id])
      redirect_to root_url if @task.nil?
    end

    def count_tasks
      @user = current_user
      @done_count = @user.tasks.done.count
      @todo_count = @user.tasks.todo.count
    end
end
