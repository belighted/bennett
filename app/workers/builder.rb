class Builder
  def self.enqueue(build)
    queue_name = 'Builder for '+build.project.name
    Resque::Job.create(queue_name, self, build.id)
  end

  def self.perform(build_id)
    ActiveRecord::Base.reconnect!
    build = Build.find(build_id)
    if build.project.recentizer? && build.project.last_build != build
      build.skip!
    else
      build.build!
    end
  end

end