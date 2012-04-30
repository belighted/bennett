class ProjectsController < ApplicationController
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html
      format.js { render partial: @projects }
    end
  end

  def show
    @builds = @project.builds.paginate(per_page: 5, page: params[:page], order: 'created_at DESC')
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
end
