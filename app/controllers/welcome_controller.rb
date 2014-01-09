class WelcomeController < ApplicationController
  skip_before_action :require_login, only: :index

  layout 'welcome'
  
  def index
    redirect_to(home_user_path(current_user)) if current_user
  end
end
