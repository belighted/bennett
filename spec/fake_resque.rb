module Resque
  def self.enqueue(*args)
    true
  end
  def self.dequeue(*args)
    true
  end
  class Job
    def self.destroy(*args)
      true
    end
  end
end
