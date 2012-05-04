class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :find_projects

  def find_projects
    @projects = current_user.try(:projects) || []
  end

  rescue_from CanCan::AccessDenied do |exception|
    if user_signed_in?
      flash[:error] = exception.message
      redirect_to root_url
    elsif User.any?
      redirect_to login_url
    else
      redirect_to new_user_url
    end
  end
end
