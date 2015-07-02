#!/bin/sh -x -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $SCRIPT_DIR/vagrant_functions.sh
USER=bahmni

DBDUMP_DIR="/bahmni/emr-functional-tests/dbdump"
BAHMNI_ENV_SCRIPTS="/bahmni/bahmni-environment/scripts"

# Restore only the mysql database
run_in_vagrant -c "gunzip -c ${DBDUMP_DIR}/mysql_backup.sql.gz > ${DBDUMP_DIR}/mysql_backup.sql"
run_in_vagrant -c "${SCRIPT_DIR}/restore-mysql.sh password ${DBDUMP_DIR}/mysql_backup.sql"

/bin/bash scripts/run.sh
