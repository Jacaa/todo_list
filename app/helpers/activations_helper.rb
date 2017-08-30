module ActivationsHelper
  
  def save_email(user)
    session[:last_email] = user.email.downcase
  end
end
