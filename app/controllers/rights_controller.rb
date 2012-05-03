class RightsController < ApplicationController
  load_and_authorize_resource

  def update
    @project = @right.project
    if @right.update_attributes params[:right]
      flash[:success] = "#{@right.user.email} is now #{@right.role} on #{@project.name}"
    else
      flash[:error] = "Error updating role: #{@right.errors.full_messages.to_sentence}"
    end
    redirect_to @project
  end

  def destroy
    if @right.destroy
      flash[:success] = "#{@right.user.email} was removed form #{@right.project.name}"
    else
      flash[:error] = 'Error removing user'
    end
    redirect_to @right.project
  end
end
