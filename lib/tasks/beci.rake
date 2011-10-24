namespace :beci do
  desc "Run the BeCI server"
  task :run do
    # Redis server
    fork do
      system "rm dump.rdb; redis-server"
    end
     
    # Rails server
    env = ENV['RAILS_ENV'] || 'production'
    system "rake db:migrate RAILS_ENV=#{env}"
    system "rake assets:precompile RAILS_ENV=#{env}" unless env=="development"
    fork do
      system "rails server -e #{env}"
    end

    # Workers
    worked_queues = []
    while true do 
      unworked_queues = Resque.queues - worked_queues
      unworked_queues.each do |q_name|
        fork do
          system "rake resque:work QUEUE='#{q_name}' RAILS_ENV=#{env}"
        end
        worked_queues << q_name
        puts "[BeCI] Spawing worker for queue: #{q_name}"
      end
      sleep 5
    end
  end
end