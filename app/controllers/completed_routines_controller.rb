class CompletedRoutinesController < ApplicationController
  before_action :user_allowed_to_complete_routine, except: :create
  
  def new
    template = Routine.find(params[:routine_id])
#    puts template.comparable_attributes
#    puts template.expectations.size
    @completed_routine = CompletedRoutine.new(template.copyable_attributes)
#    puts @completed_routine.comparable_attributes
#    puts @completed_routine.completed_expectations.size
#      
#    template.expectations.each do |e|
#      @completed_routine.completed_expectations << CompletedExpectation.new(description: e.description)
#    end
  end
  
  def create
#    puts params.inspect # Get the view working so I can see what the parameters are going to be, so I can write the test case.
    CompletedRoutine.create!(completed_routine_params)
    redirect_to home_user_path(current_user)
  end
  
  private

  def user_allowed_to_complete_routine
    params.require(:routine_id) # Theoretically, this isn't right, but it seems to work.
    current_user.can_complete?(params[:routine_id]) || not_found
  end
  
  def completed_routine_params
    r = params.require(:completed_routine)
    r.permit(:routine_id, :person_id, :comment, :name,
      completed_expectations_attributes: [:description, :observation, :comment]
    )
  end
end
