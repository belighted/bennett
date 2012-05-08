PID_FILE = 'tmp/workers.pid'

# Start a worker with proper env vars and output redirection
def run_worker(queue)
  ops = {:pgroup => true, :err => [(Rails.root + "log/resque_err").to_s, "a"],
                          :out => [(Rails.root + "log/resque_stdout").to_s, "a"]}
  env_vars = {"QUEUE" => queue.to_s}
  ## Using Kernel.spawn and Process.detach because regular system() call would
  ## cause the processes to quit when capistrano finishes
  pid = spawn(env_vars, "rake resque:work", ops)
  Process.detach(pid)
  pid
end

def kill_workers(pids)
  pids = [pids].compact unless pids.is_a? Enumerable
  unless pids.empty?
    system "kill -s QUIT #{pids.join(' ')}"
  end
end

namespace :workers do
  task :setup => :environment

  desc "Restart running workers"
  task :restart => :environment do
    Rake::Task['workers:stop'].invoke
    Rake::Task['workers:start'].invoke
  end

  desc "Quit running workers"
  task :stop => :environment do
    begin
      pids = [File.read(PID_FILE)]
      File.delete PID_FILE
    rescue
      pids = []
    end
    pids.concat(Resque.workers.first.worker_pids) if Resque.workers.any?
    kill_workers pids
  end

  desc "Start workers"
  task :start => :environment do
    ops = {:pgroup => true, :err => [(Rails.root + "log/resque_err").to_s, "a"],
                            :out => [(Rails.root + "log/resque_stdout").to_s, "a"]}
    pid = spawn("rake workers:run RAILS_ENV=#{Rails.env}", ops)
    Process.detach(pid)
    File.open(PID_FILE, 'w') do |f|
      f.write pid
    end
  end

  desc "Run workers"
  task :run => :environment do
    worked_queues = []
    pids = {}
    while true do
      unworked_queues = Resque.queues - worked_queues
      unworked_queues.each do |q_name|
        puts "[Bennett] Spawing worker for queue: #{q_name}"
        pids[q_name] = run_worker(q_name)
        worked_queues << q_name
      end
      deprecated_queues = worked_queues - Resque.queues
      deprecated_queues.each do |q_name|
        puts "[Bennett] Terminating queue: #{q_name}"
        kill_workers pids[q_name]
        worked_queues.delete q_name
      end
     	sleep 5
    end
  end
end
