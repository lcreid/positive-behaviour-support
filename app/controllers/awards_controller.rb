=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end

=begin
This works, but in hindsight I'm not so sure that it was a clever
idea to make a controller without a model behind it.
This probably should have gone in as an extra route in goal,
or I should have actually modelled an award.
=end
class AwardsController < ApplicationController
  before_action :user_allowed_to_give_award
  
  def new
  end
  
  def create
    if @goal.award(params[:number_of_rewards] || 1)
      redirect_to person_path(@goal.person)
    else
      render "new"
    end
  end

  private

  def user_allowed_to_give_award
    params.require(:goal_id) # Theoretically, this isn't right, but it seems to work.
    @goal = Goal.find(params[:goal_id])
    @goal.can_be_completed_by?(current_user) || not_found
  end
end
