# Bennett

![](http://platypus.belighted.com/bennett/bennett-large.png)

Bennett is a continuous integration server aimed at Ruby on Rails applications and Git.

It is born from our need for a CI server with several key features such as support for multiple projects and users, and our desire for something as easy as possible to manage.

It is designed to be full-featured yet simple to use, somewhere half-way between [CI Joe](https://github.com/defunkt/cijoe) and [Jenkins](http://jenkins-ci.org/)

## Features

* Designed for multiple projects
* Complete user access management per-project, including read-only access
* Run any test command
* Support for [rbenv](https://github.com/sstephenson/rbenv) and [RVM](https://rvm.io/)
* Automatically build projects using a Git hook

#### Compared to [CI Joe](https://github.com/defunkt/cijoe), Bennett is

* Multi-project and multi-user
* Heavy

#### Compared to [Jenkins](http://jenkins-ci.org/), Bennett is

* Easy to deploy in a Rails-centric environment
* Easy to use (IMHO)
* Limited

#### Compared to [Travis](http://travis-ci.org/), Bennett is

* Able to test your proprietary projects for free
* Not SaaS, and must be hosted and configured
* Not distributed

## Screenshots

![](http://platypus.belighted.com/bennett/bennett_scr1.png)
![](http://platypus.belighted.com/bennett/bennett_scr2.png)

## Setup

#### Redis

Bennett depends on Redis >= 2.4

With Homebrew on OS X:

    brew install redis

On Linux or OS X without Homebrew:

    wget http://redis.googlecode.com/files/redis-2.4.15.tar.gz (or whatever the latest stable version is)
    tar -xf redis-2.4.15.tar.gz
    cd redis-2.4.15
    sudo make install

You can obviously use your system package manager, but verify the
version first, as some Linux distros still offer Redis 1.2. You should
also make sure Redis doesn't start as a service, as Bennett will launch
it itself.

#### Bennett

1. Clone the Bennett source code and move to the **deploy** branch
    
   `git clone git@github.com:belighted/bennett.git -b deploy`

   `cd bennett`
    
2. Install the dependencies with Bundler. Bennett uses rbenv and runs on Ruby 1.9.3-p194, so make sure that's the current version if you're using RVM

   `bundle install`

3. Run the setup

   `rake bennett:setup`
   
4. Configure your hostname in `config/environments/production.rb`
   
5. Start it!

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

When you're ready, request a new build. When it's done, you (or the last person to commit on the project) should receive an e-mail with the result.

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

## Updating

Just run `./update`

This script will stop Bennett, do a `git pull`, and restart.

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

## Help us make it even better !

Bennett was originally designed as an internal tool, with our specific needs in mind.
If you have suggestions on where to go next, we would love for you to [send
feedback](http://bennett.uservoice.com)!

If you encounter a bug or want to help us with some code, please submit an issue or fork the project on [GitHub](https://github.com/belighted/bennett)!

![](http://platypus.belighted.com/bennett/bennett-small.png)

> Copyright (c) 2012 Belighted sprl
> 
> Bennett is distributed under the MIT license, see LICENSE
