=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
class UsersController < ApplicationController
  before_action :validate_login
  before_action :set_user
  
  def show
  end
  
  def home
  end
  
  private
  
  def validate_login
    not_found if current_user.nil? || current_user.id.to_s != params[:id]
  end
  
  def set_user
    @user = User.find(params[:id])
  end
end
