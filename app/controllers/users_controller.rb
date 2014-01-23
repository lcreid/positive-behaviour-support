=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
class UsersController < ApplicationController
  before_action :user_allowed
  before_action :validate_login
  before_action :set_user
  
  def show
  end
  
  def home
#    flash.notice = "Test notice"
#    flash.alert = "Test alert\nline 2\nline 3\nline 4\nline 5\nline 6"
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    puts "USER PARAMS: #{user_params.inspect}"
    if @user.update_attributes(user_params)
      redirect_to home_user_path(@user)
    else
      render "edit"
    end
  end
  
  private
  
  def validate_login
    not_found if current_user.nil? || current_user.id.to_s != params[:id]
  end
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def user_allowed
    params[:id].nil? || current_user.id.to_s == params[:id] || not_found
  end
  
  def user_params
    params.require(:user).permit(:time_zone)
  end
end
