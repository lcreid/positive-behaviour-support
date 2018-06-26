# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :user_allowed
  before_action :validate_login
  before_action :set_user

  layout "new_application", only: :home

  def show; end

  def home
    #    flash.notice = "Test notice"
    #    flash.alert = "Test alert\nline 2\nline 3\nline 4\nline 5\nline 6"
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      redirect_to home_user_path(@user)
    else
      render "edit"
    end
  end

  private

  def validate_login
    not_found if current_user.nil? || current_user.id.to_s != params[:id]
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_allowed
    params[:id].nil? || current_user.id.to_s == params[:id] || not_found
  end

  def user_params
    params.require(:user).permit(:time_zone)
  end
end
