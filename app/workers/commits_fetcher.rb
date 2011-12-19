class CommitsFetcher
  @queue = 'Commits Fetcher'
  def self.perform(build_id)
    build = Build.find(build_id)
    build.fetch_commit!
    Builder.enqueue(build)
  end
end