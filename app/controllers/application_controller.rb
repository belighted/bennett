class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :find_projects
  before_filter :authenticate

  def find_projects
    @projects = Project.all
  end

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == 'ci' && password == 'belighted!1234'
    end
  end

end
