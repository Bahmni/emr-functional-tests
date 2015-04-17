#!/bin/sh -x -e

PATH_OF_CURRENT_SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $PATH_OF_CURRENT_SCRIPT/vagrant_functions.sh
USER=bahmni

DBDUMP_DIR="/bahmni/emr-functional-tests/dbdump"
BAHMNI_ENV_SCRIPTS="/bahmni/bahmni-environment/scripts"

# Restore only the mysql database
run_in_vagrant -c "${BAHMNI_ENV_SCRIPTS}/restore-mysql.sh password ${DBDUMP_DIR}/mysql_backup.sql"

/bin/bash scripts/run.sh
