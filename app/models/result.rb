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
  
  before_create :set_defaults
  def set_defaults
    self.status_id = STATUS[:pending]
  end
  
  scope :recent_first, order('end_time DESC')
  scope :older_first, order('start_time ASC')
  
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
end
