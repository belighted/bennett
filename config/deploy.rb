require 'capistrano_colors'

set :application,       "beci"
set :repository,        "git@github.com:belighted/beci.git"
set :app_server,        :passenger
set :scm,               :git
set :deploy_via,        :remote_cache
set :branch,            "master"
set :user,              "nja"
set :deploy_to,         "/Users/nja/Sites/beci"
set :rails_env,         "production"
set :ssh_options,       {:forward_agent => true}
set :use_sudo,          false
load "deploy/assets"
set :normalize_asset_timestamps, false

set :rvm_path,              "/Users/nja/.rvm/"
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
require 'bundler/capistrano'
set :rvm_ruby_string, 'ruby-1.9.2-p290@beci'
set :rvm_type, :user


role :web, "192.168.1.99"                          # Your HTTP server, Apache/etc
role :app, "192.168.1.99"                          # This may be the same as your `Web` server
role :db,  "192.168.1.99", :primary => true        # This is where Rails migrations will run

# rvm
after "deploy", "rvm:trust_rvmrc"

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
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
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

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust \#\{release_path\}"
  end
end
