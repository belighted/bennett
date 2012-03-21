class Result < ActiveRecord::Base
  STATUS = {
    :pending => 'pending',
    :busy    => 'busy',
    :failed  => 'failed',
    :passed  => 'passed',
    :skipped => 'skipped'
  }

  belongs_to :build
  belongs_to :command

  validates :status_id, :inclusion => { :in => STATUS.values }
  validates_presence_of :build, :command

  before_destroy :delete_log_file

  before_validation :set_default_status, :on => :create
  before_create :build_log_path

  def set_default_status
    self.status_id = STATUS[:pending]
  end

  def build_log_path
    self.log_path = "#{Rails.root}/log/build_#{build.project.name.parameterize('_')}_#{build.id}_#{command.name.parameterize('_')}.log"
  end

  scope :recent_first, order('end_time DESC')
  scope :older_first, order('start_time ASC')

  def delete_log_file
    if File.exists?(log_path)
      File.delete(log_path)
    end
  end

  def last
    recent_first.limit(1)
  end

  def first
    older_first.limit(1)
  end

  def status
    STATUS.detect {|k,v| v==status_id}.first
  end

  def in_status?(status)
    status_id == STATUS[status]
  end

  def pending?
   in_status? :pending
  end

  def busy?
    in_status? :busy
  end

  def passed?
    in_status? :passed
  end

  def failed?
    in_status? :failed
  end

  def skipped?
    in_status? :skipped
  end

  def log
    File.read log_path
  end
end
