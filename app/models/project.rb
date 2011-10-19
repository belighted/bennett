class Project < ActiveRecord::Base
  has_many :builds
  has_many :commands
  accepts_nested_attributes_for :commands
  
  validate :unique_command_positions
  
  def last_pending_build
    builds.last_pending
  end
  
  def status
    builds.any? ? builds.last.status : :no_builds
  end
  
  def unique_command_positions
    errors.add(:commands, 'must have a non-ambiguous order') unless commands.map(&:position).size == commands.map(&:position).uniq.size
  end
end
