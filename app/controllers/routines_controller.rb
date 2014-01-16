class RoutinesController < ApplicationController
  before_action :user_allowed_to_access_routine, except: :create
  
  def show
    @routine = Routine.find(params[:id])
  end
  
  private

  def user_allowed_to_access_routine
    params.require(:id) # Theoretically, this isn't right, but it seems to work.
    current_user.can_access?(params[:id]) || not_found
  end
end
