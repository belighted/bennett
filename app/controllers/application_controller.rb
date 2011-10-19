class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :find_projects
  
  def find_projects
    @projects = Project.all
  end
end
