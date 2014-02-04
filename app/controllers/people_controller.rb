class PeopleController < ApplicationController
  before_action :user_allowed_to_modify_person, except: [:create, :new]

  def edit
  end
  
  def new
    @person = Person.new
    @person.creator = current_user
  end
  
  def create
    @person = Person.new(person_params)
    current_user.linkup(@person)
    
    @person.update_team(params[:person][:users])
    if @person.save
      redirect_to edit_user_path(current_user)
    else
      render "new"
    end
  end
  
  def update
    @person.update_attributes(person_params)
    
    @person.update_team(params[:person][:users])
    if @person.save
      redirect_to edit_user_path(current_user)
    else
      render "edit"
    end
  end
  
  def destroy
    @person.destroy
    redirect_to :back
  end
  
  def show
    
  end
  
  private

  def user_allowed_to_modify_person
    params.require(:id) # Theoretically, this isn't right, but it seems to work.
    @person = Person.find(params[:id])
    current_user.can_modify_person?(@person) || not_found
  end
  
  def person_params
    params.require(:person).permit(:name, :creator_id)
  end
end
