class TasksController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = "Task created"
      redirect_to root_url
    else
      flash[:danger] = "Content can't be blank!"
      redirect_to root_url
    end
  end

  def destroy
    @task.destroy
    flash[:info] = "Task destroyed."
    redirect_to root_url
  end

  private

    def task_params
      params.require(:task).permit(:content)
    end

    def correct_user
      @task = current_user.tasks.find_by(id: params[:id])
      redirect_to root_url if @task.nil?
    end
end
