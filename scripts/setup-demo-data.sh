#!/bin/bash
set -e -x

TEMP_SCRIPT_DIR=`dirname -- "$0"`
SCRIPT_DIR=`cd $TEMP_SCRIPT_DIR; pwd`


${SCRIPT_DIR}/setup-database.sh
mysql -uroot -ppassword < ${SCRIPT_DIR}/delete-test-data.sql