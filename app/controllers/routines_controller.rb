class RoutinesController < ApplicationController
  before_action :user_allowed_to_access_routine, except: [:create, :new]

  def show
    @routine = Routine.find(params[:id])
  end

  def edit
    render "new"
  end

  def new
    params.require(:person)
    @routine = Routine.new
    @routine.person_id = params[:person][:id]
  end

  def create
    @routine = Routine.new(routine_params)
    if @routine.save
      redirect_to person_path(@routine.person)
    else
      render "new"
    end
  end

  def update
    @routine.update_attributes(routine_params)
    if @routine.save
      redirect_to person_path(@routine.person)
    else
      render "new"
    end
  end

  def destroy
    @routine.destroy
    redirect_back fallback_location: root_path
  end

  private

  def user_allowed_to_access_routine
    params.require(:id) # Theoretically, this isn't right, but it seems to work.
    @routine = Routine.find(params[:id])
    current_user.can_access?(@routine) || not_found
  end

  def routine_params
    params.require(:routine).permit(:name, :person_id, :goal_id, :_destroy,
      expectations_attributes: [:description, :routine_id, :id])
  end
end
