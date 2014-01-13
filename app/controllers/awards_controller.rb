=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
class AwardsController < ApplicationController
  before_action :user_allowed_to_give_award
  
  def new
  end
  
  def create
    @goal.award (params[:number_of_rewards] || 1).to_i
    redirect_to home_user_path(current_user)
  end

  private

  def user_allowed_to_give_award
    params.require(:goal_id) # Theoretically, this isn't right, but it seems to work.
    @goal = Goal.find(params[:goal_id])
    @goal.can_be_completed_by?(current_user) || not_found
  end
end
