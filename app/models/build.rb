class Build < ActiveRecord::Base
  belongs_to :project
  has_many :results
  
  scope :recent_first, order('date DESC')
  
  def last
    recent_first.limit(1)
  end
  
  def results_in_status(status)
    results.select {|r| r.in_status? status}.count
  end
  
  def short_hash
    hash.try :[], 0..9
  end
  
  def status
    [:busy, :failed, :pending].each do |status|
      return status unless results_in_status(status).zero?
    end
    :passed
  end
  
  def start_time
    results.first.start_time
  end
  
  def end_time
    results.last.end_time
  end
end
