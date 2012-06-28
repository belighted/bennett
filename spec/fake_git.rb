module Git
  def self.open(*args)
    FakeGit.new
  end
end

class FakeGit
  def fetch
    FakeGitFetch.new
  end
end

class FakeGitFetch
  def include?(*args)
    true
  end
end
