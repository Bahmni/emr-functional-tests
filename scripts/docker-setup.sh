# This Source Code Form is subject to the terms of the Mozilla Public License,
# v. 2.0. If a copy of the MPL was not distributed with this file, You can
# obtain one at https://www.bahmni.org/license/mplv2hd.
#
# Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
# graphic logo is a trademark of OpenMRS Inc.

docker stop bahmni
docker rm -v bahmni

docker run -v /var/lib/go-agent/pipelines/Functional_Tests/emr-functional-tests/:/emr-functional-tests -v /var/lib/go-agent/pipelines/Functional_Tests/rpms:/packages --name bahmni -d bahmni/bahmni
