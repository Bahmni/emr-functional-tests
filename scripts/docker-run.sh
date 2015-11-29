#!/bin/bash --login
yum remove -y openmrs bahmni-emr bahmni-web

yum localinstall -y /packages/openmrs*.rpm
yum localinstall -y /packages/bahmni-emr*.rpm
yum localinstall -y /packages/bahmni-web*.rpm

service openmrs restart
service httpd restart

sleep 30

bundle exec rspec spec/features/*.rb --format documentation --format html --out spec-results/index.html
