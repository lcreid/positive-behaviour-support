class GoalsController < ApplicationController
  before_action :user_allowed_to_access_goal, except: [:create, :new]
  before_action :prep_new_goal, only: [:create, :new]

  def show
    @goal = Goal.find(params[:id])
  end

  def edit
    render "new"
  end

  def new
  end

  def create
    @goal.update_attributes(goal_params)
    if @goal.save
      redirect_to edit_person_path(@person)
    else
      render "new"
    end
  end

  def update
    @goal.update_attributes(goal_params)
    if @goal.save
      redirect_to edit_person_path(@goal.person)
    else
      render "new"
    end
  end

  def destroy
    @goal.destroy
    redirect_back fallback_location: root_path
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

  def prep_new_goal
    params.require(:person_id)
    @person = Person.find(params[:person_id])
    @goal = Goal.new
    @goal.person_id = params[:person_id]
  end
end
