# This Source Code Form is subject to the terms of the Mozilla Public License,
# v. 2.0. If a copy of the MPL was not distributed with this file, You can
# obtain one at https://www.bahmni.org/license/mplv2hd.
#
# Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
# graphic logo is a trademark of OpenMRS Inc.

#!/bin/bash --login
rvm use 2.2.2
set -ex
bundle install
if [ "$TEST_ENV" = "soak" ]
then
        bundle exec rspec spec/features/{multiple_dashboard_visit_pages.rb,new_patient_visit.rb} --format documentation --format html --out spec-results/index.html
elif [ "$TEST_ENV" = "offline-ci" ]
then
        bundle exec rspec spec/features/offline/*.rb --format documentation --format html --out spec-results/index.html
else
        bundle exec rspec spec/features/*.rb --format documentation --format html --out spec-results/index.html
fi
