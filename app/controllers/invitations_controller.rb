# frozen_string_literal: true

class InvitationsController < ApplicationController
  skip_before_action :require_login, only: :respond

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.create(invitation_params) do |i|
      i.invitor = current_user
      i.disposition = "pending"
    end
    if @invitation.save
      # TODO: Make it deliver later in the background. Probably.
      LinkMailer.invitation_email(@invitation).deliver_now
      redirect_to edit_user_path(current_user)
    else
      render "new"
    end
  end

  def respond
    unless logged_in?
      session[:original_url] = request.original_url
      redirect_to(signin_path) && return
    end

    # TODO: Check that the invitation is for the current user.
    unless params[:id] &&
           (@invitation = Invitation.find(params[:id])) &&
           params[:token] &&
           @invitation.token == params[:token] &&
           params[:disposition]
      not_found
    end

    if (@invitation.disposition = params[:disposition]) == "accept"
      current_user.linkup(@invitation.invitor)
      current_user.save
    end

    @invitation.save!
    redirect_to edit_user_path(current_user)
  end

  private

  def invitation_params
    params.require(:invitation).permit(:invitor, :e_mail, :token, :disposition)
  end
end
