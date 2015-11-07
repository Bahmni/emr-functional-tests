#!/bin/bash --login
rvm use 1.9.3
set -ex
bundle install
if [ "$TEST_ENV" = "soak" ]
then
        bundle exec rspec spec/features/{multiple_dashboard_visit_pages.rb,new_patient_visit.rb} --format documentation --format html --out spec-results/index.html
else
        bundle exec parallel_rspec -n 4 spec/features/*.rb --format documentation --format html --out spec-results/index.html
fi