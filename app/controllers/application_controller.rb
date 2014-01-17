=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

=begin rdoc
Throw a page not found exception (404).
Use this in controllers when you want to hide a link, e.g.
show a not found if an unauthorized user tries to go to the
admin pages.
=end  
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

#  private
  
  ###### Session helpers ######

=begin rdoc
Return the user currently logged-in.
=end  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
  
=begin rdoc
Log in a user.
=end  
  def log_in(user)
    session[:user_id] = user.is_a?(User) ? user.id: user
  end
  
=begin rdoc
Throw a page not found exception (404) if there is no logged in user.
=end  
  def require_login
    not_found unless logged_in?
  end
  before_action :require_login

=begin rdoc
Return nil if no user is logged in.
=end  
  def logged_in?
    session[:user_id]
  end
end
