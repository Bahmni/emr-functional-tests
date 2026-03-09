# This Source Code Form is subject to the terms of the Mozilla Public License,
# v. 2.0. If a copy of the MPL was not distributed with this file, You can
# obtain one at https://www.bahmni.org/license/mplv2hd.
#
# Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
# graphic logo is a trademark of OpenMRS Inc.

#!/bin/bash --login
yum remove -y openmrs bahmni-emr bahmni-web

yum localinstall -y /packages/openmrs*.rpm
yum localinstall -y /packages/bahmni-emr*.rpm
yum localinstall -y /packages/bahmni-web*.rpm

service openmrs restart
service httpd restart

sleep 30

bundle exec rspec spec/features/*.rb --format documentation --format html --out spec-results/index.html
