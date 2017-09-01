class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]
  before_action :get_user,       only: [:edit, :update]
  
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      msg = "Please check your email for ending signup process, "
      msg += "Email with activation link should be delivered soon."
      flash[:warning] = msg
      save_email(@user)
      redirect_to root_url
    else
       respond_to :js
    end
  end

  def edit
  end

  def update
    old_email = @user.email
    if @user.update_attributes(user_params)
      unless old_email == user_params[:email]
        log_out
        @user.update_attribute(:activated, false)
        @user.send_activation_email
        flash[:warning] = "Profile updated! Now please check your email for activation link."
        save_email(@user)
        redirect_to root_url
      else
        flash.now[:success] = "Profile updated!"
        render 'edit'
      end
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:info] = "Account deleted!"
    redirect_to root_url
  end

  private 

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

    def get_user
      @user = User.find(params[:id])
      @auth_info = session[:omniauth] if session[:omniauth]
    end

    def correct_user
      get_user
      redirect_to(root_url) unless correct_user?(@user)
    end
end
