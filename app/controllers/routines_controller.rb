# frozen_string_literal: true

class RoutinesController < ApplicationController
  # include GetBack
  before_action :user_allowed_to_access_routine, except: %i[create new]
  before_action :set_back, only: %i[edit new]

  def show
    @routine = Routine.find(params[:id])
  end

  def edit
    render "new"
  end

  def new
    @routine = Routine.new
    @routine.person_id = params[:person_id]
    @person = Person.find(params[:person_id])
  end

  def create
    # FIXME: person_ids can be spoofed.
    @person = Person.find(params[:person_id])
    @routine = @person.routines.build(routine_params)
    if @routine.save
      redirect_to where_we_came_from_url(person_path(@routine.person))
    else
      render "new"
    end
  end

  def update
    @routine.update_attributes(routine_params)
    if @routine.save
      redirect_to where_we_came_from_url(person_path(@routine.person))
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
      expectations_attributes: %i[description routine_id id])
  end
end
