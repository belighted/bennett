class Build < ActiveRecord::Base
  belongs_to :project
  has_many :results, :autosave => true, :dependent => :destroy

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

  def duration
    end_time - start_time rescue nil
  end

  def status
    [:busy, :failed, :pending, :skipped].each do |status|
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
      result.skip
    end
  end

  def update_commit!
    git = Git.open(project.folder_path)
    git.reset_hard
    git.checkout(project.branch)
    git.pull
    git.checkout(commit_hash)
  end

  def build!
    update_commit!
    results.each do |result|
      result.start_now
      if status == :failed
        result.skip
      else
        result.busy
        commands = [ 'unset RAILS_ENV RUBYOPT BUNDLE_GEMFILE BUNDLE_BIN_PATH GEM_HOME RBENV_DIR GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE',
                     '[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"',
                     '[[ -s "$HOME/.rbenv/bin/rbenv" || -s "/usr/local/bin/rbenv" ]] && export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:/usr/local/bin:$PATH" && eval "$(rbenv init -)"',
                     "cd #{project.folder_path}",
                     "#{result.command.command}" ]
        res = system "#{commands.join(';')} > #{result.log_path} 2>&1"
        if res
          result.pass
        else
          result.fail
        end
      end
      result.end_now
    end
    CiMailer.build_result(self).deliver
  end

  def fetch_commit!
    git = Git.open(project.folder_path)
    git.fetch
    branch = git.branches["remotes/origin/#{project.branch}"] # TODO: make this smarter
    commit = branch.gcommit.log(1).first
    self.commit_hash = commit.sha
    self.commit_message = commit.message
    self.commit_author = commit.author.name
    self.commit_author_email = commit.author.email
    self.commit_date = commit.date
    save!
  end

  def new_activity?
    git = Git.open(project.folder_path)
    res = git.fetch
    res.include?(project.branch)
  end

  def delete_jobs_in_queues
    Resque.dequeue(CommitsFetcher, id)
    queue_name = 'Builder for '+ project.name
    Resque::Job.destroy(queue_name, Builder, id)
  end

end
