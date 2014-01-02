class WelcomeController < ApplicationController
  layout 'welcome'
  
  def index
    redirect_to(home_user_path(current_user)) if current_user
  end
end
