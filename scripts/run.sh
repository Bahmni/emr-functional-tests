#!/bin/bash --login
rvm use 1.9.3
set -ex
bundle install
bundle exec rspec spec/features/*.rb --format documentation --format html --out spec-results/index.html
