class ResultsController < ApplicationController

  def show
    @project = Project.find(params[:project_id])
    @build = Build.find(params[:build_id])
    @result = Result.find(params[:id])
  end

end