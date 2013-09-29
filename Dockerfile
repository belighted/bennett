FROM        ubuntu:12.04
MAINTAINER  zdkaster "nx2zdk@gmail.com"

# apt-get deps

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list

RUN apt-get update -y
RUN apt-get install -y -q sudo
RUN apt-get install -y -q git
RUN apt-get install -y -q build-essential
RUN apt-get install -y -q libicu-dev
RUN apt-get install -y -q gcc
RUN apt-get install -y -q make
RUN apt-get install -y -q g++
RUN apt-get install -y -q libc6-dev
RUN apt-get install -y -q redis-server
RUN apt-get install -y -q curl
RUN apt-get install -y -q libssl-dev
RUN apt-get install -y -q zlib1g-dev
RUN apt-get install -y -q sendmail

EXPOSE  6379

#Install rbenv ruby 1.9.3-p327 and bundler

RUN git clone https://github.com/sstephenson/rbenv.git /usr/local/rbenv
RUN mkdir /usr/local/rbenv/plugins
RUN git clone https://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build

ENV RBENV_ROOT /usr/local/rbenv
ENV PATH /usr/local/rbenv/shims:/usr/local/rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN rbenv install 1.9.3-p327

ENV RBENV_VERSION 1.9.3-p327

RUN gem install bundler
ENV PATH /usr/local/rbenv/versions/1.9.3-p327/bin:${PATH}

#Deploy Bennnet

RUN apt-get install -y -q libsqlite3-dev
RUN apt-get install -y -q nodejs
RUN apt-get install -y -q cron

RUN git clone https://github.com/zdk/bennett -b docker
ENV RAILS_ENV production
RUN (cd bennett && bundle install && rake bennett:setup)
EXPOSE 4000
ADD ./.docker/start.sh ./start.sh
RUN chmod +x ./start.sh
EXPOSE 4000
CMD ["./start.sh"]
