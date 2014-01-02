class UsersController < ApplicationController
  before_action :validate_login
  before_action :set_user
  
  def show
  end
  
  def home
  end
  
  private
  
  def validate_login
    not_found if current_user.nil? || current_user.id.to_s != params[:id]
  end
  
  def set_user
    @user = User.find(params[:id])
  end
end
