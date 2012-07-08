class ProjectsController < ApplicationController
  load_and_authorize_resource :except => :add_user_or_invite

  def index
    respond_to do |format|
      format.html
      format.js { render partial: @projects }
    end
  end

  def show
    @builds = @project.builds.includes(:results).paginate(per_page: 5, page: params[:page], order: 'created_at DESC')
    @available_users = User.all - @project.users
    @pending_invitations = Invitation.find_all_by_project_id(@project.id)
    respond_to do |format|
      format.html
      format.js { render partial: 'projects/builds', locals: {project: @project, builds: @builds} }
    end
  end

  def new
  end

  def edit
  end

  def create
    if @project.save
      flash[:success] = 'Project was successfully created.'
      redirect_to @project
    else
      render action: "new"
    end
  end

  def update
    if @project.update_attributes(params[:project])
      flash[:success] = 'Project was successfully updated.'
      redirect_to @project
    else
      params[:project][:commands_attributes].present? ? redirect_to(@project) : render(action: "edit")
    end
  end

  def destroy
    @project.destroy
    flash[:success] = "Project correctly destroyed."
    redirect_to projects_url
  end

  def add_user_or_invite
    @project = Project.find(params[:project_id])
    if params[:user_id].present?
      object = Right.new project: @project, user: User.find(params[:user_id]), role: params[:role]
      success = "#{object.user.email} is now #{object.role} on #{@project.name}"
    else
      object = Invitation.new project: @project, issuer: current_user, role: params[:role], email: params[:email]
      success = "#{object.email} was invited as #{object.role} on #{@project.name}"
    end
    authorize! :create, object
    if object.save
      flash[:success] = success
    else
      flash[:error] = "Error adding user to project: #{object.errors.full_messages.to_sentence}"
    end
    redirect_to @project
  end
end
