#!/bin/sh -x -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $SCRIPT_DIR/vagrant_functions.sh
USER=bahmni

DBDUMP_DIR="/bahmni/emr-functional-tests/dbdump"
BAHMNI_DB_SCRIPTS="/bahmni/emr-functional-tests/scripts"

# Restore only the mysql database
run_in_vagrant -c "gunzip -c ${DBDUMP_DIR}/mysql_backup.sql.gz > ${DBDUMP_DIR}/mysql_backup.sql"
run_in_vagrant -c "${BAHMNI_DB_SCRIPTS}/run-mysql-script.sh password ${DBDUMP_DIR}/mysql_backup.sql"

/bin/bash scripts/run.sh
