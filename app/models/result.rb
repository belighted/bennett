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

  validates :status_id, :inclusion => { :in => STATUS.values, :on => :update }
  validates_presence_of :build, :command

  before_destroy :delete_log_file

  before_create :set_defaults

  def set_defaults
    self.status_id = STATUS[:pending]
    self.log_path = "#{Rails.root}/log/build_#{build.project.name.parameterize('_')}_#{build.id}_#{command.name.parameterize('_')}.log"
  end

  scope :recent_first, order('end_time DESC')
  scope :older_first, order('start_time ASC')
  scope :ordered_by_position, -> { joins(:command).order("commands.position ASC") }

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
    STATUS.detect {|k,v| v==status_id}.try(:first)
  end

  def in_status?(status)
    status_id == STATUS[status]
  end

  STATUS.keys.each do |status|
    define_method status do
      update_attribute :status_id, STATUS[status]
    end

    define_method "#{status}?" do
      in_status? status
    end
  end

  def start_now
    update_attribute :start_time, Time.now
  end

  def end_now
    update_attribute :end_time, Time.now
  end

  def log
    File.read log_path
  end
end
