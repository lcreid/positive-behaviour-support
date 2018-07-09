# frozen_string_literal: true

class GoalsController < ApplicationController
  before_action :user_allowed_to_access_goal, except: %i[create new]
  before_action :prep_new_goal, only: %i[create new]
  before_action :set_back, only: %i[edit new]

  def create
    @goal.update_attributes(goal_params)
    if @goal.save
      redirect_to where_we_came_from_url(edit_person_path(@person))
    else
      render "new"
    end
  end

  def destroy
    @goal.destroy
    redirect_back fallback_location: root_path
  end

  def show
    @goal = Goal.find(params[:id])
  end

  def update
    @goal.update_attributes(goal_params)
    if @goal.save
      redirect_to where_we_came_from_url(edit_person_path(@goal.person))
    else
      render "new"
    end
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

  # Set the URL to which to return after creating or updating something.
  def set_back
    session[:here_after_save] = request.headers["HTTP_REFERER"]
    # puts session[:here_after_save]
  end

  def where_we_came_from_url(fallback = root_path)
    session[:here_after_save] || fallback
  end
  helper_method :where_we_came_from_url
end
