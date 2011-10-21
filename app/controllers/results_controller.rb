class ResultsController < ApplicationController
  def show
    @project = Project.find(params[:project_id])
    @build = Build.find(params[:build_id])
    @result = Result.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @result }
      format.js { render partial: @result }
    end
  end
end