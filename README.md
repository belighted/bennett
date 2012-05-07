# Bennett

![](http://labs.belighted.com/bennett/bennett-large.png)

Bennett is a continuous integration server aimed at Ruby on Rails applications and Git.

It is designed to be full-featured yet simple to use, somewhere half-way between [CI Joe](https://github.com/defunkt/cijoe) and [Jenkins](http://jenkins-ci.org/)

## Features

* Designed for multiple projects
* Complete user access management per-project, including read-only access
* Run any test command
* Support for [rbenv](https://github.com/sstephenson/rbenv) and [RVM](https://rvm.io/)
* Automatically build projects using a Git hook

## Setup

1. Install [Redis](http://redis.io/download)
2. Clone the Bennett source code somewhere and move to the **deploy** branch
    
   `git clone git@github.com:belighted/bennett.git`
    
   `git checkout deploy`
    
3. Install the dependencies with Bundler. Bennett uses rbenv and runs on Ruby 1.9.3-p0, so make sure that's the current version if you're using RVM

   `bundle install`

4. Run the setup

   `rake bennett:setup`
   
5. Configure your hostname in `config/environments/production.rb`
   
6. Start it!

   `rake bennett:start`
   
   You can now access Bennett at [localhost:4000](localhost:4000) and create your first admin account.
   
The last step starts the Redis server, a master worker process and unicorn. To stop it all, run `rake bennett:stop`.
   
## Adding a project

To add a project to be tested, simply clone the code wherever you want and add this location from the app.

If you run Bennett locally, it is **highly** recommended that you use a different folder than your development folder, as Bennett will be doing pulls and checkouts regularly and it will **very probably** break everything.

Now add test commands from the Commands tab of your project page, a usual list for a Rails project would be:

* bundle install
* bundle exec rake db:reset RAILS_ENV=test
* bundle exec rspec
* bundle exec cucumber

When you're ready, go to the Builds tab and request a new build. When it's done, you (or the last person to commit on the project) should receive an e-mail with the result.

## Automatic testing

A CI server is only really useful is everything is automatic, so we highly recommend you configure a Git hook to start building after each push.

To do so, first copy the **Post-Receive URL for Git hook** from the Settings tab of your project.

#### GitHub

If your code is on GitHub, go to your repository settings, then Service Hooks, and add the URL you copied to the **Post-Receive URLs**.

#### GitLab

If you're using GitLab, go to your project page, open the **Hooks** tab, and paste the URL you copied.

## User roles

When giving a user access to a project, you can choose between 3 roles:

* **admin**: can do anything to a project, including deleting it
* **developer**: can manually request a build, but not edit the project settings
* **auditor**: read-only access

On top of per-project permissions, global admins can be defined from the **Admins** menu. These users have full admin access to every project, and can add new projects to be tested.

## Advanced configuration

### Unicorn

You can edit the Unicorn configuration at `config/unicorn.rb`. 2 particularly usefull settings are:

* **worker_processes**: number of web threads to run. It is low by default because your CI server doesn't usually get much traffic and we don't want to hog resources
* **listen**: address and port Unicorn listens to. If port 4000 doesn't do it for you, or if you want to setup something like Nginx in front of Unicorn to host multiple apps, that's what you want to change

### Redis

If you have lots of projects, you may want to tweak the Redis configuration at `config/redis.conf`.

### MOAR

If you don't want to run Bennett all-in-one, you can run components separately and leverage an existing Redis or Passenger server. Here is what `rake bennett:start` does:

* `redis-server config/redis.conf`
* `rake workers:restart RAILS_ENV=production`
* `rake unicorn:restart RAILS_ENV=production`

Have a look at the `lib/tasks/` folder to go even deeper.

## Updating

1. `rake bennett:stop`
2. `git pull`
3. `rake bennett:start`

## Help us make it even better !

Bennett was originally designed as an internal tool, with our specific needs in mind. If you encounter bugs or have suggestions on where to go next, please submit an issue or fork the project on [GitHub](https://github.com/belighted/bennett)!

![](http://labs.belighted.com/bennett/bennett-small.png)
