require 'training'

# From: http://railscasts.com/episodes/241-simple-omniauth-revised
# With modifications
class SessionsController < ApplicationController
  skip_before_action :require_login, only: :create

  def create
    new_user = ! User.from_omniauth_exists?(env["omniauth.auth"])
    user = User.from_omniauth_or_create(env["omniauth.auth"])
    log_in(user)
    Training.create(user) if new_user
    # I modified the next line to go to the user's home
    redirect_to home_user_path(user), notice: "Signed in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end
end
