=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
class CompletedRoutinesController < ApplicationController
  before_action :user_allowed_to_complete_routine, only: [:new]
  before_action :user_allowed_to_edit, except: [:new, :create, :index, :report]
  
  def new
    template = Routine.find(params[:routine_id])
#    puts template.comparable_attributes
#    puts template.expectations.size
    @completed_routine = CompletedRoutine.new(template.copyable_attributes)
    @completed_routine.recorded_by = current_user
#    puts @completed_routine.comparable_attributes
#    puts @completed_routine.completed_expectations.size
#      
#    template.expectations.each do |e|
#      @completed_routine.completed_expectations << CompletedExpectation.new(description: e.description)
#    end
  end
  
  def create
    params[:completed_routine][:recorded_by_id] = current_user.id
    @completed_routine = CompletedRoutine.new(completed_routine_params)
    if @completed_routine.save
      redirect_to person_path(@completed_routine.person)
    else
      render "new"
    end
  end
  
  def edit
  end
  
  def update
    params[:completed_routine][:updated_by_id] = current_user.id
    @completed_routine.update_attributes(completed_routine_params)
    if @completed_routine.save
      redirect_to person_path(@completed_routine.person)
    else
      render "edit"
    end
  end
  
  def index
    params.require(:person_id)
    @person = Person.find(params[:person_id])
  end
  
  def report
  end
  
  private

  def user_allowed_to_complete_routine
    params.require(:routine_id) # Theoretically, this isn't right, but it seems to work.
    current_user.can_complete?(params[:routine_id]) || not_found
  end

  def user_allowed_to_edit
    @completed_routine = CompletedRoutine.find(params[:id])
    current_user.can_modify?(@completed_routine) || not_found
  end
  
  def completed_routine_params
    r = params.require(:completed_routine)
    params[:completed_routine][:routine_done_at] = 
      params[:completed_routine][:routine_done_at_date] +
      " " +
      params[:completed_routine][:routine_done_at_time]
    r.permit(:id, 
      :routine_id, 
      :person_id, 
      :category,
      :comment, 
      :name, 
      :routine_done_at, 
      :recorded_by_id, 
      :updated_by_id,
      completed_expectations_attributes: [:id, :description, :observation, :comment]
    )
  end
end
