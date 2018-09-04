# frozen_string_literal: true

# This works, but in hindsight I'm not so sure that it was a clever
# idea to make a controller without a model behind it.
# This probably should have gone in as an extra route in goal,
# or I should have actually modelled an award.

class AwardsController < ApplicationController
  before_action :user_allowed_to_give_award

  def new; end

  def create
    if @goal.award(params[:number_of_rewards] || 1)
      redirect_to person_path(@goal.person)
    else
      render "new"
    end
  end

  private

  def user_allowed_to_give_award
    params.require(:goal_id)
    @goal = current_user.goals.find(params[:goal_id])
    @goal.can_be_completed_by?(current_user) || not_found
  rescue ActiveRecord::RecordNotFound
    not_found
  end
end
