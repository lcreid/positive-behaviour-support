=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
class WelcomeController < ApplicationController
  skip_before_action :require_login, only: :index

#  layout 'welcome'
  
  def index
    redirect_to(home_user_path(current_user)) if current_user
  end
  
  def privacy
  end
  
  def terms
  end
end
