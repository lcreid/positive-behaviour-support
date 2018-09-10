# frozen_string_literal: true

require "training"

# From: http://railscasts.com/episodes/241-simple-omniauth-revised
# With modifications
# Google stuff at: https://cloud.google.com/console/project/apps~serene-craft-460S
# Yahoo!: http://developer.apps.yahoo.com/projects/SHQdFY4m
# Facebook: https://developers.facebook.com/x/apps/494216987366288/dashboard/
# Twitter: https://dev.twitter.com/apps/5595046/show

class SessionsController < ApplicationController
  skip_before_action :require_login

  def create
    new_user = !User.from_omniauth_exists?(request.env["omniauth.auth"])
    user = User.from_omniauth_or_create(request.env["omniauth.auth"])
    log_in(user)

    # Get time zone and set it if not set in DB.
    #    puts "User time zone: #{user.time_zone}"
    #    puts "request.env['omniauth.params']['time_zone']: #{request.env['omniauth.params']['time_zone']}"
    #    puts "request.env['omniauth.params']: #{request.env['omniauth.params']}"
    if request.env["omniauth.params"] && request.env["omniauth.params"]["time_zone"]
      tz = Rack::Utils.unescape(request.env["omniauth.params"]["time_zone"])
      #      puts tz
      if user.time_zone.blank?
        #        puts "Set time zone to #{tz}"
        user.time_zone = tz
        user.save!
        flash.notice = "Your time zone has been set to #{user.time_zone}." \
                       " If this is wrong," \
                       " please go to your #{view_context.link_to('profile', edit_user_path(user))}" \
                       " to change it."
      elsif user.time_zone != tz
        #        puts "New time zone to #{tz}"
        flash.notice = "It appears you are now in the #{tz} time zone." \
                       " Please go to your #{view_context.link_to('profile', edit_user_path(user))}" \
                       " if you want to change your time zone."
      end
    else
      logger.info("#{user.name} (id: #{user.id}) logged in with no time zone from browser.")
    end

    # Now create training data if a new user. Have to set the time zone explicitly
    if new_user
      Time.use_zone(user.time_zone) do
        Training.create(user)
      end
    end

    # I modified the next line to go to the user's home
    if session[:original_url]
      redirect_to session[:original_url]
      session.delete(:original_url)
    elsif user.subjects.count == 1
      redirect_to person_path(user.subjects.first)
    else
      redirect_to home_user_path(user) # , notice: "Signed in!"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url # , notice: "Signed out!"
  end
end
