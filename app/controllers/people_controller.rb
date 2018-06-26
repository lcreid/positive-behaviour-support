# frozen_string_literal: true

class PeopleController < ApplicationController
  before_action :user_allowed_to_modify_person, except: %i[create new]

  layout "new_application", only: :show

  def edit; end

  def new
    @person = Person.new
    @person.creator = current_user
  end

  def create
    @person = Person.new(person_params)
    current_user.linkup(@person)

    @person.update_team(params[:person][:users])
    if @person.save
      redirect_to person_path(@person)
    else
      render "new"
    end
  end

  def update
    @person.update_attributes(person_params)

    @person.update_team(params[:person][:users])
    if @person.save
      redirect_to person_path(@person)
    else
      render "edit"
    end
  end

  def destroy
    @person.destroy # TODO: I don't think I wan to destroy any data, so re-think this.
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
    params.require(:id) # Theoretically, this isn't right, but it seems to work.
    @person = Person.find(params[:id])
    current_user.can_modify_person?(@person) || not_found
  end

  def person_params
    params.require(:person).permit(:name, :short_name, :real_name, :creator_id)
  end
end
