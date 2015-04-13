#!/bin/bash --login
rvm use 1.9.3
set -ex
bundle install
bundle exec rspec spec/features/*.rb --format html --out results.html
