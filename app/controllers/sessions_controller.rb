=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
require 'training'

# From: http://railscasts.com/episodes/241-simple-omniauth-revised
# With modifications
# From: http://railscasts.com/episodes/241-simple-omniauth-revised
# Google stuff at: https://cloud.google.com/console/project/apps~serene-craft-460S
# Yahoo!: http://developer.apps.yahoo.com/projects/SHQdFY4m
# Facebook: https://developers.facebook.com/x/apps/494216987366288/dashboard/
# Twitter: https://dev.twitter.com/apps/5595046/show

class SessionsController < ApplicationController
  skip_before_action :require_login

  def create
    new_user = ! User.from_omniauth_exists?(env["omniauth.auth"])
    user = User.from_omniauth_or_create(env["omniauth.auth"])
    log_in(user)
    
    # Get time zone and set it if not set in DB.
#    puts "User time zone: #{user.time_zone}"
#    puts "env['omniauth.params']['time_zone']: #{env['omniauth.params']['time_zone']}"
#    puts "env['omniauth.params']: #{env['omniauth.params']}"
    if env["omniauth.params"] && env["omniauth.params"]["time_zone"]
      tz = Rack::Utils.unescape(env["omniauth.params"]["time_zone"])
#      puts tz
      if user.time_zone.blank? 
#        puts "Set time zone to #{tz}"
        user.time_zone = tz
        user.save!
        flash.notice = "Your time zone has been set to #{user.time_zone}." +
          " If this is wrong," +
          " please click #{view_context.link_to('here', edit_user_path(user))}" +
          " to change your profile."
      elsif user.time_zone != tz
#        puts "New time zone to #{tz}"
        flash.notice = "It appears you are now in the #{tz} time zone. " +
          "Please click #{view_context.link_to(edit_user_path(user), 'here')}" +
          " if you want to change your time zone."
      end
    else
      logger.info("#{user.name} (id: #{user.id}) logged in with no time zone from browser.")
    end      
    
    # Now create training data if a new user. Have to set the time zone explicitly
    Time.use_zone(user.time_zone) do
      Training.create(user) 
    end if new_user
    
    # I modified the next line to go to the user's home
    redirect_to home_user_path(user)#, notice: "Signed in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url#, notice: "Signed out!"
  end
end
