class SessionsController < ApplicationController

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        remember(user) if params[:session][:remember_me] == '1'
        redirect_to root_url
      else
        msg = "Account not activated. "
        msg += "Check your email for the activation link."
        save_email(user)
        flash[:warning] = msg
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
    email = auth[:info][:email]
    unless user
      unless User.exists?(email: email)
        user = User.create_user(auth)
        user.send_welcome_email
      else
        existing_user = User.find_by_email(email)
        if existing_user.provider?
          msg = "Looks like you have signed up using "
          msg += "#{existing_user.provider.split('_').first.upcase} before. "
          msg += "Please use the existing account."
        else
          msg = "Looks like you have signed up using this email before. "
          msg += "Please use the existing account. "
          msg += "Set new password if you don't remeber old one."
        end
        flash[:info] = msg
      end
    end
    omniauth_log_in user
    redirect_to root_url
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
