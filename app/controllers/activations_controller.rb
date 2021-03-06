class ActivationsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_email(session[:last_email])
    if @user
      @user.send_activation_email
      flash[:warning] = "Email should be delivered soon, be patient :)"
      redirect_to root_url
    else
      flash[:danger] = "Email not found."
      redirect_to new_activation_url
    end
  end
  
  def edit
    user = User.find_by_email(params[:email])
    if user && !user.activated? && (user.activation_token == params[:id])
      user.activate
      log_in user
      redirect_to root_url
    else
      flash[:danger] = "Invalid activation link."
      redirect_to root_url
    end
  end
end
