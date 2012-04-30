class Project < ActiveRecord::Base
  has_many :builds, :dependent => :destroy
  has_many :commands, :dependent => :destroy
  accepts_nested_attributes_for :commands
  has_many :rights
  has_many :users, :through => :rights

  validates :folder_path, :uniqueness => true
  validate :unique_command_positions
  validates_presence_of :name, :folder_path, :branch

  def last_build
    builds.last
  end

  def status
    builds.any? ? builds.last.status : :no_builds
  end

  def unique_command_positions
    errors.add(:commands, 'must have a non-ambiguous order') unless commands.map(&:position).size == commands.map(&:position).uniq.size
  end

end
