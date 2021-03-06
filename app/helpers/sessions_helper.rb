module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id if user
  end

  def log_out
    session.delete(:user_id)
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
    cookies.delete(:user_name)
    cookies.delete(:user_image)
    @current_user = nil
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id) || User.find_by(uid: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && (user.remember_token == cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def correct_user?(user)
    user == current_user
  end
  
  def logged_in?
    !current_user.nil?
  end
  
  def remember(user)
    if user
      cookies.permanent.signed[:user_id] = user.id
      cookies.permanent[:remember_token] = user.remember_token
    end
  end

  def save_info(auth)
    cookies.permanent[:user_name] = auth['info']['name']
    cookies.permanent[:user_image] = auth['info']['image']
  end
end
