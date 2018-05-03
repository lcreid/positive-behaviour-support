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

  before_action :prepare_for_mobile

  def title
    "Clean Routines"
  end
  helper_method :title
  
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

#=begin rdoc
#Make a link look like a button.
#=end
#  def link_to_button(text, path, options = {})
#    link_to "<button type=\"button\">#{text}</button>".html_safe, path
#  end
#  helper_method :link_to_button
  
  ###### Session helpers ######

=begin rdoc
Return the user currently logged-in.
=end  
  def current_user
#    begin
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
#    rescue ActiveRecord::RecordNotFound 
#      logger.warn "Session terminated because user not in database (break-in attempt?)."
#      log_out
#      raise
#    end
  end
  helper_method :current_user
  
=begin rdoc
Log in a user.
=end  
  def log_in(user)
    session[:user_id] = user.is_a?(User) ? user.id: user
  end
  
=begin rdoc
Log in a user.
=end  
  def log_out
    session[:user_id] = nil
  end
  
=begin rdoc
Throw a routing error if there is no logged in user.
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

###### Time zone support
# FROM http://railscasts.com/episodes/106-time-zones-revised

  around_action :user_time_zone, if: :logged_in?

private
  
  def user_time_zone(&block)
#    puts "user_time_zone current_user: #{current_user.inspect}"
#    puts "user_time_zone block doesn't exist." unless block
    Time.use_zone(current_user.time_zone, &block)
  end

###### Mobile
# From http://railscasts.com/episodes/199-mobile-devices?view=asciicast
  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS/
    end
  end
  helper_method :mobile_device?

  def prepare_for_mobile
    session[:mobile_param] = params[:mobile] if params[:mobile]
    request.format = :mobile if mobile_device?
  end
end
