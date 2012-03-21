require 'capistrano_colors'

set :application,       "beci"
set :repository,        "git@git.belighted.com:beci.git"
set :scm,               :git
set :deploy_via,        :remote_cache
set :branch,            "master"
set :user,              "ci"
set :deploy_to,         "/Users/ci/Sites/beci"
set :rails_env,         "production"
set :ssh_options,       {:forward_agent => true}
set :use_sudo,          false
load "deploy/assets"
set :normalize_asset_timestamps, false

# unicorn informations
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{shared_path}/tmp/unicorn.pid"
set :unicorn_bin, "bundle exec unicorn"

# rbenv
set :default_environment, {
  'PATH' => "/Users/ci/.rbenv/shims:/Users/ci/.rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
}

require 'bundler/capistrano'

role :web, "192.168.1.99"                          # Your HTTP server, Apache/etc
role :app, "192.168.1.99"                          # This may be the same as your `Web` server
role :db,  "192.168.1.99", :primary => true        # This is where Rails migrations will run

# Symplinks, cron & db dump
after "deploy:update_code", "deploy:symlink_directories_and_files"
after "deploy:symlink_directories_and_files", "deploy:restart_workers"

def run_remote_rake(rake_cmd) 
  rake_args = ENV['RAKE_ARGS'].to_s.split(',')
  cmd = "cd #{fetch(:latest_release)} && #{fetch(:rake, "rake")} RAILS_ENV=#{fetch(:rails_env, "production")} #{rake_cmd}"
  cmd += "['#{rake_args.join("','")}']" unless rake_args.empty?
  run cmd
  set :rakefile, nil if exists?(:rakefile)
end

namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do
    run <<-CMD
      cd #{current_path} && #{unicorn_bin} -c #{unicorn_config} -E #{rails_env} -D
    CMD
  end

  task :force_stop, :roles => :app, :except => { :no_release => true } do
    run <<-CMD
      if [ -e #{unicorn_pid} ]; then
        kill -9 $(cat #{unicorn_pid});
      fi
    CMD
  end

  task :stop, :roles => :app, :except => { :no_release => true } do
    run <<-CMD
      if [ -e #{unicorn_pid} ]; then
        kill $(cat #{unicorn_pid});
      fi
    CMD
  end

  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run <<-CMD
      if [ -e #{unicorn_pid} ]; then
        kill -s QUIT $(cat #{unicorn_pid});
      fi
    CMD
  end

  task :reload, :roles => :app, :except => { :no_release => true } do
    run <<-CMD
      if [ -e #{unicorn_pid} ]; then
        kill -s USR2 $(cat #{unicorn_pid});
      fi
    CMD
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run <<-CMD
      if [ -e #{unicorn_pid} ]; then
        kill -9 $(cat #{unicorn_pid});
        sleep 5;
        cd #{current_path} && #{unicorn_bin} -c #{unicorn_config} -E #{rails_env} -D;
      fi
    CMD
  end

  desc 'Symlink shared directories and files'
  task :symlink_directories_and_files do
    run "ln -s #{shared_path}/database.yml #{release_path}/config/database.yml"
    run "ln -s #{shared_path}/production.sqlite3 #{release_path}/db/production.sqlite3"
  end

  desc "Restart Resque Workers"
  task :restart_workers, :roles => :db do
    run_remote_rake "workers:restart_workers"
  end
end

desc "Create shared folders."
after 'deploy:setup', :roles => :app do
  # for unicorn
  run "mkdir -p #{shared_path}/tmp"
end