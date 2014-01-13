class AwardsController < ApplicationController
  before_action :user_allowed_to_give_award
  
  def new
  end
  
  def create
    @goal.award
    redirect_to home_user_path(current_user)
  end

  private

  def user_allowed_to_give_award
    params.require(:goal_id) # Theoretically, this isn't right, but it seems to work.
    @goal = Goal.find(params[:goal_id])
    @goal.can_be_completed_by?(current_user) || not_found
  end
end
