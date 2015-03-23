SCRIPTS_DIR=`dirname $0`
BASE_DIR="${SCRIPTS_DIR}/.."
DBDUMP_DIR="${BASE_DIR}/dbdump"
BAHMNI_ENV_SCRIPTS="${BASE_DIR}/../bahmni-environment/scripts"

sh ${BAHMNI_ENV_SCRIPTS}/restore-mysql.sh password ${DBDUMP_DIR}/mysql_backup.sql
sh ${BAHMNI_ENV_SCRIPTS}/restore-pgsql.sh ${DBDUMP_DIR}/pgsql_backup.sql
