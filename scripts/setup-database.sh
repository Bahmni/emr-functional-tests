SCRIPTS_DIR=`dirname $0`
BASE_DIR="${SCRIPTS_DIR}/.."
DBDUMP_DIR="${BASE_DIR}/dbdump"

gunzip -c ${DBDUMP_DIR}/mysql_backup.sql.gz > ${DBDUMP_DIR}/mysql_backup.sql
sh ${SCRIPTS_DIR}/run-mysql-script.sh password ${DBDUMP_DIR}/mysql_backup.sql
gunzip -c ${DBDUMP_DIR}/pgsql_backup.sql.gz > ${DBDUMP_DIR}/pgsql_backup.sql
sh ${SCRIPTS_DIR}/run-pgsql-script.sh ${DBDUMP_DIR}/pgsql_backup.sql
