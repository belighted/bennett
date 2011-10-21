namespace :beci do
  desc "Run the BeCI server"
  task :run, :workers do |t, args|
    # Redis server
    fork do 
      system "redis-server"
    end
    
    # Git worker
    fork do
      system "rake resque:work QUEUE='Commits Fetcher'"
    end
    
    # Build workers
    workers = ENV['WORKERS'].to_i || 1
    workers.times do
      fork do
        system "rake resque:work QUEUE='*'"
      end
    end
    
    # Rails server
    env = ENV['RAILS_ENV'] || 'production'
    system "rake db:migrate RAILS_ENV=#{env}"
    system "rake assets:precompile RAILS_ENV=#{env}"
    system "rails server -e #{env}"
  end
end