class ActivationsController < ApplicationController

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
