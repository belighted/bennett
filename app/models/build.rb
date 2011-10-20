class Build < ActiveRecord::Base
  belongs_to :project
  has_many :results, :autosave => true
  
  scope :recent_first, order('created_at DESC')
  
  before_create :create_default_results
  
  def last
    recent_first.limit(1)
  end
  
  def results_in_status(status)
    results.select {|r| r.in_status? status}.count
  end
  
  def short_hash
    commit_hash.try :[], 0..9
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
  
  def create_default_results
    project.commands.each do |command|
      results.build(:command => command)
    end
  end
  
  def has_commit_info?
    commit_hash.present? && commit_message.present? && commit_author.present? && commit_date.present?
  end
  
  # WORK
  
  def skip!
    results.each do |result|
      result.update_attribute :status_id, Result::STATUS[:skipped]
    end
  end
  
  def build!
    results.each do |result|
      result.update_attribute :status_id, 'busy'
      sleep 5
      result.update_attribute :status_id, 'passed'
      sleep 1
    end
  end
  
  def fetch_commit!
    self.commit_hash = '654654653176523'
    self.commit_message = 'My commit'
    self.commit_author = 'jco'
    self.commit_date = Time.now
    save!
  end
end
