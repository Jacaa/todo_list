class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]
  before_action :get_user,       only: [:edit, :update]
  
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email for ending signup process."
      redirect_to root_url
    else
      redirect_to request.referrer || root_url
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated!"
      redirect_to root_url
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:info] = "User deleted"
    redirect_to root_url
  end

  private 

    def user_params
      params.require(:user).permit(:name, :email, 
                                   :password, :password_confirmation)
    end

    def get_user
      @user = User.find(params[:id])
    end

    def correct_user
      get_user
      redirect_to(root_url) unless correct_user?(@user)
    end
end
