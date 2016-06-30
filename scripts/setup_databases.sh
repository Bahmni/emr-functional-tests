SCRIPTS_DIR=`dirname $0`
BASE_DIR="${SCRIPTS_DIR}/.."
DBDUMP_DIR="${BASE_DIR}/dbdump"

sh ${SCRIPTS_DIR}/drop_databases.sh

gunzip -c ${DBDUMP_DIR}/openmrs_backup.sql.gz > ${DBDUMP_DIR}/openmrs_backup.sql
sh ${SCRIPTS_DIR}/run-mysql-script.sh password ${DBDUMP_DIR}/openmrs_backup.sql

#gunzip -c ${DBDUMP_DIR}/openelis_backup.sql.gz > ${DBDUMP_DIR}/openelis_backup.sql
#sh ${SCRIPTS_DIR}/run-pgsql-script.sh ${DBDUMP_DIR}/openelis_backup.sql
#
#gunzip -c ${DBDUMP_DIR}/openerp_backup.sql.gz > ${DBDUMP_DIR}/openerp_backup.sql
#sh ${SCRIPTS_DIR}/run-pgsql-script.sh ${DBDUMP_DIR}/openerp_backup.sql
