namespace :bennett do

  desc "Start Bennett"
  task :start do
    Rails.env = 'production'
    system <<-CMD
      redis-server config/redis.conf
    CMD
    Rake::Task['workers:restart'].invoke
    Rake::Task['unicorn:restart'].invoke
    puts 'Bennett is now running at http://localhost:4000'
  end

  desc "Stop Bennett"
  task :stop do
    Rails.env = 'production'
    Rake::Task['unicorn:stop'].invoke
    Rake::Task['workers:stop'].invoke rescue Errno::ECONNREFUSED
    system <<-CMD
      if [ -e tmp/redis.pid ]; then
        kill $(cat tmp/redis.pid);
      fi
    CMD
  end

  desc "Setup Bennet and check dependencies"
  task :setup do
    Rails.env = 'production'
    Dir.mkdir 'tmp' rescue Errno::EEXIST
    Rake::Task['db:migrate'].invoke
    Rake::Task['assets:precompile'].invoke
    system <<-CMD
      whenever -w
      command -v redis-server >/dev/null 2>&1 || echo >&2 "Could not find the redis-server executable. Please make sure Redis is installed and redis-server is in your path"
    CMD
  end

  desc "Restart Bennett"
  task :restart do
    Rails.env = 'production'
    Rake::Task['bennett:stop'].invoke
    Rake::Task['bennett:start'].invoke
  end

end
