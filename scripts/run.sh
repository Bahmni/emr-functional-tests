#!/bin/sh
#rvm use 1.9.3
set -ex
bundle install
bundle exec rspec spec/features/*.rb
