class Builder
  def self.enqueue(build)
    queue_name = build.project.name.to_sym
    Resque.remove_queue(queue_name) if true
    Resque::Job.create(queue_name, self, build.id)
  end
  
  def self.perform(build_id)
    build = Build.find(build_id)
    build.results.each do |result|
      result.update_attribute :status_id, 'busy'
      sleep 5
      result.update_attribute :status_id, 'passed'
      sleep 1
    end
  end
end