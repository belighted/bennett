class Project < ActiveRecord::Base
  has_many :builds
  has_many :commands
  
  def last_pending_build
    builds.last_pending
  end
  
  def status
    builds.any? ? builds.last.status : :no_builds
  end
end
