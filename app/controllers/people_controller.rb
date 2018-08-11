# frozen_string_literal: true

class PeopleController < ApplicationController
  before_action :user_allowed_to_modify_person, except: %i[create new]

  def edit
  end

  def new
    @person = Person.new
    @person.creator = current_user
  end

  def create
    @person = current_user.subjects.build(person_params)
    @person.caregivers << current_user

    # @person.update_team(params[:person][:users])
    if @person.save
      redirect_to person_path(@person)
    else
      render "new"
    end
  end

  def update
    @person.update_attributes(person_params)

    # @person.update_team(params[:person][:users])
    if @person.save
      redirect_to person_path(@person)
    else
      render "edit"
    end
  end

  def destroy
    @person.destroy # TODO: I don't think I want to destroy any data, so re-think this.
    redirect_back fallback_location: root_path
  end

  def show
    @completed_routines = @person.completed_routines
                                 .reorder(routine_done_at: :desc)
                                 .page(params[:page]).per(15)
  end

  def reports; end

  private

  def user_allowed_to_modify_person
    params.require(:id)
    @person = current_user.subjects.find(params[:id])
    current_user.can_modify_person?(@person) || not_found
  rescue ActiveRecord::RecordNotFound
    not_found
  end

  def person_params
    # TODO: Get rid of creator_id. Should always be current_user, and can be spoofed if it's a param.
    params.require(:person).permit(:name, :short_name, :real_name, :creator_id, caregiver_ids: [])
  end
end
