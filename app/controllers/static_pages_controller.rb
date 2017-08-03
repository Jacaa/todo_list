class StaticPagesController < ApplicationController
  
  def index
    @user = current_user if logged_in?
  end
end
