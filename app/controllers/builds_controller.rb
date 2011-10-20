class BuildsController < ApplicationController
  # POST /builds
  # POST /builds.json
  def create
    @project = Project.find(params[:project_id])
    @build = @project.builds.new(params[:build])

    respond_to do |format|
      if @build.save
        Resque.enqueue(CommitsFetcher, @build.id)
        Builder.enqueue(@build)
        format.html { redirect_to @project, notice: 'Build successfully added to queue.' }
        format.json { render json: @build, status: :created, location: @build }
      else
        format.html { redirect_to @project, notice: 'Error adding build.' }
        format.json { render json: @build.errors, status: :unprocessable_entity }
      end
    end
  end
end
