class PasswordResetsController < ApplicationController
  before_action :get_user,         only: [:edit, :update]
  before_action :valid_user,       only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_email(params[:password_reset][:email].downcase)
    if @user
      if @user.provider?
        @user.send_account_info_email
      else
        @user.create_password_reset_token
        @user.send_password_reset_email
      end
      flash[:info] = "Email was sent with instructions."
      redirect_to root_url
    else
      flash[:danger] = "Email not found."
      redirect_to new_password_reset_url
    end
  end
  
  def edit
  end
  
  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to root_url
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by_email(params[:email])
    end

    def valid_user
      unless @user && @user.activated? && (@user.password_reset_token == params[:id])
        msg = "Your account was not activated."
        msg += " Check your email for activation link."
        flash[:danger] = msg
        redirect_to root_url
      end
    end

    def check_expiration
      if @user.password_reset_token_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
