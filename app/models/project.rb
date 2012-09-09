class Project < ActiveRecord::Base
  has_many :builds, dependent: :destroy
  has_many :commands, dependent: :destroy
  accepts_nested_attributes_for :commands
  has_many :rights
  has_many :users, through: :rights

  validates :folder_path, uniqueness: true
  validate :unique_command_positions
  validates :name, :folder_path, :branch, :hook_token, presence: true

  before_validation :create_hook_token, on: :create

  scope :public, where(public: true)

  def self.build_all_nightly!
    Project.where(build_nightly: true).each do |project|
      build = project.builds.create
      Resque.enqueue(CommitsFetcher, build.id)
    end
  end

  def last_build
    builds.last
  end

  def last_finished_build
    builds.last_finished
  end

  def status
    never_built? ? :no_builds : last_build.status
  end

  def finished_status
    last_finished_build.try :status
  end
  def has_finished_status?
    finished_status.present?
  end

  def never_built?
    builds.none?
  end

  def busy_or_pending?
    last_build.present? && (last_build.busy? || last_build.pending?)
  end

  def unique_command_positions
    errors.add(:commands, 'must have a non-ambiguous order') unless commands.map(&:position).size == commands.map(&:position).uniq.size
  end

private

  def create_hook_token
    self.hook_token = SecureRandom.hex(8)
  end

end
