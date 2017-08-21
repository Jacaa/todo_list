class TasksController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :change]
  before_action :correct_user, only: [:destroy, :change]

  def create
    @task = current_user.tasks.build(task_params)
    @task.save
    redirect_to root_url
  end

  def destroy
    @task.destroy
    redirect_to root_url
  end

  def change
    @task.change_status
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
