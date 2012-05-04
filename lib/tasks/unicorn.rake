namespace :unicorn do

  task :start do
    spawn "unicorn -c config/unicorn.rb -E #{Rails.env} -D"
  end
  
  task :stop do
    spawn <<-CMD
      if [ -e tmp/unicorn.pid ]; then
        kill $(cat tmp/unicorn.pid);
      fi
    CMD
  end

  task :restart do
    Rake::Task['unicorn:stop'].invoke
    sleep 5
    Rake::Task['unicorn:start'].invoke
  end

end
