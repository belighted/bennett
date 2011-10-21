class BuildsController < ApplicationController
  # POST /builds
  # POST /builds.json
  def create
    @project = Project.find(params[:project_id])
    @build = @project.builds.new(params[:build])

    respond_to do |format|
      if @build.save
        Resque.enqueue(CommitsFetcher, @build.id)
        format.html { redirect_to @project, notice: 'Build successfully added to queue.' }
        format.json { render json: @build, status: :created, location: @build }
      else
        format.html { redirect_to @project, notice: 'Error adding build.' }
        format.json { render json: @build.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @build = Build.find(params[:id])

    if @build.destroy
      flash[:notice] = "Build successfully deleted."
      redirect_to project_path(@build.project)
    else
      flash[:error] = "Error deleting build."
      redirect_to project_path(@build.project)
    end
  end

end
