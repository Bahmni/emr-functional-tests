#!/bin/sh -x -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $SCRIPT_DIR/vagrant_functions.sh
USER=bahmni

DBDUMP_DIR="/bahmni/emr-functional-tests/dbdump"
BAHMNI_DB_SCRIPTS="/bahmni/emr-functional-tests/scripts"

# Restore only the mysql database
sh ${BAHMNI_DB_SCRIPTS}/setup_databases.sh

/bin/bash scripts/run.sh
