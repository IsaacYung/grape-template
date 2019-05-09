#!/bin/sh

cd /my-application

bundle exec rake db:migrate

bundle exec unicorn -c unicorn.rb
