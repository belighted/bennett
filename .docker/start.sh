#!/bin/sh

/etc/init.d/redis-server restart
cd bennett && rake bennett:start


#wtf? avoid shell exits after "docker run -d <image>"
cd bennett; tail -f log/*
