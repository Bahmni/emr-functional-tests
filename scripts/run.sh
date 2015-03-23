#!/bin/sh
if [[ -s "/etc/profile.d/rvm.sh" ]] ; then
  source /etc/profile.d/rvm.sh
fi
rvm use 1.9.3
set -ex
bundle install
bundle exec rspec spec/features/*.rb
