# From: http://railscasts.com/episodes/241-simple-omniauth-revised
# With modifications
class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    # I modified the next line to go to the user's home
    redirect_to home_user_path(user), notice: "Signed in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end
end
