class InvitationsController < ApplicationController
  load_and_authorize_resource

  def update
    @project = @invitation.project
    if @invitation.update_attributes params[:invitation]
      flash[:success] = "#{@invitation.email} is now invited as #{@invitation.role} on #{@project.name}"
    else
      flash[:error] = "Error updating invitation: #{@invitation.errors.full_messages.to_sentence}"
    end
    redirect_to @project
  end

  def destroy
    if @invitation.destroy
      flash[:success] = "#{@invitation.email} is no longer invited to #{@invitation.project.name}"
    else
      flash[:error] = 'Error recalling invitation'
    end
    redirect_to @invitation.project
  end
end
