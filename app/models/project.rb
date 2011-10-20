class Project < ActiveRecord::Base
  has_many :builds
  has_many :commands
  accepts_nested_attributes_for :commands

  after_create :create_folder

  validate :unique_command_positions

  def create_folder
    folder_name = "#{Rails.root}/projects/#{name.parameterize('_')}"
    FileUtils.mkpath(folder_name)
    update_attribute(:folder_path, folder_name)
    FileUtils.mkpath(folder_name+"/shared")
  end

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
