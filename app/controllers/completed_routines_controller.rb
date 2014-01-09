class CompletedRoutinesController < ApplicationController
  before_action :user_allowed_to_complete_routine, except: :create
  
  def new
    template = Routine.find(params[:routine_id])
    @completed_routine = CompletedRoutine.new(
      routine_id: template.id, 
      name: template.name,
      person_id: template.person_id
      )
      
    template.expectations.each do |e|
      @completed_routine.completed_expectations << CompletedExpectation.new(description: e.description)
    end
  end
  
  def create
    CompletedRoutine.create!(completed_routine_params)
    redirect_to home_user_path(current_user)
  end
  
  private

  def user_allowed_to_complete_routine
    params.require(:routine_id)
    current_user.can_complete?(params[:routine_id]) || not_found
  end
  
  def completed_routine_params
    r = params.require(:completed_routine)
    r.require(:routine_id)
    r.require(:person_id)
    r.permit(:routine_id, :person_id, :comment, :name)
  end
end
