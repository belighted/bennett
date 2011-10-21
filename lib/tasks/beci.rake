namespace :beci do
  desc "Run the BeCI server"
  task :run, :workers do |t, args|
    # Prepare
    env = ENV['RAILS_ENV'] || 'production'
    system "rake db:migrate RAILS_ENV=#{env}"
    system "rake assets:precompile RAILS_ENV=#{env}" unless env=="development"
    
    # Redis server
    fork do 
      system "redis-server"
    end
    
    # Git worker
    fork do
      system "rake resque:work QUEUE='Commits Fetcher' RAILS_ENV=#{env}"
    end
    
    # Build workers
    workers = ENV['WORKERS'].present? ? ENV['WORKERS'].to_i : 1
    workers.times do
      fork do
        system "rake resque:work QUEUE='*' RAILS_ENV=#{env}"
      end
    end
    
    # Rails server
    system "rails server -e #{env}"
  end
end