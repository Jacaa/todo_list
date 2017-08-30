class SessionsController < ApplicationController

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        remember(user) if params[:session][:remember_me] == '1'
        redirect_to root_url
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        save_email(user)
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash[:danger] = "Invalid email/password!"
      redirect_to root_url
    end
  end

  def create_omniauth
    auth = request.env['omniauth.auth']
    session[:omniauth] = auth.except('extra')
    user = User.sign_in_from_omniauth(auth)
    unless user
      user = User.create_user(auth)
      user.send_welcome_email
    end
    omniauth_log_in user
    redirect_to root_url
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
