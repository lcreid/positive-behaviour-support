class GoalsController < ApplicationController
  before_action :user_allowed_to_access_goal, except: [:create, :new]
  
  def show
    @goal = Goal.find(params[:id])
  end
  
  def edit
  end
  
  def new
    params.require(:person)
    @goal = Goal.new
    @goal.person_id = params[:person][:id]
  end
  
  def create
    @goal = Goal.new(goal_params)
    if @goal.save
      redirect_to edit_person_path(@goal.person)
    else
      render "new"
    end
  end
  
  def update
    @goal.update_attributes(goal_params)
    if @goal.save
      redirect_to edit_person_path(@goal.person)
    else
      render "edit"
    end
  end
  
  def destroy
    @goal.destroy
    redirect_to :back
  end
  
  private

  def user_allowed_to_access_goal
    params.require(:id) # Theoretically, this isn't right, but it seems to work.
    @goal = Goal.find(params[:id])
    current_user.can_access_goal?(@goal) || not_found
  end
  
  def goal_params
    params.require(:goal).permit(:name, :person_id, :description, :target)
  end
end
