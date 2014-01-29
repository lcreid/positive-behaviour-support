class LinksController < ApplicationController
  before_action :user_allowed_to_modify_link

  def destroy
    @link = Link.find(params[:id])
    @link.person_a.unlink(@link.person_b)
    redirect_to :back
  end
  
  private

  def user_allowed_to_modify_link
    params.require(:id) # Theoretically, this isn't right, but it seems to work.
    current_user.can_modify_link?(params[:id]) || not_found
  end
end
