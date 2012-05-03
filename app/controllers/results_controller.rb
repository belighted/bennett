class ResultsController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :build, :through => :project
  load_and_authorize_resource :through => :build

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @result }
      format.js { render partial: @result }
    end
  end
end