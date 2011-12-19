class CommitsFetcher
  @queue = 'Commits Fetcher'
  def self.perform(build_id)
    ActiveRecord::Base.reconnect!
    build = Build.find(build_id)
    build.fetch_commit!
    Builder.enqueue(build)
  end
end