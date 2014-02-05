=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
class CompletedRoutinesController < ApplicationController
  before_action :user_allowed_to_complete_routine, except: [:create, :index]
  
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
    if CompletedRoutine.create(completed_routine_params)
      redirect_to home_user_path(current_user)
    else
      render "new"
    end
  end
  
  def edit
    @completed_routine = CompletedRoutine.find(params[:id])
  end
  
  def update
    @completed_routine = CompletedRoutine.find(params[:id])
    @completed_routine.update_attributes(completed_routine_params)
    if @completed_routine.save
      redirect_to :back
    else
      render "edit"
    end
  end
  
  def index
    params.require(:person_id)
    @person = Person.find(params[:person_id])
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
