SCRIPTS_DIR=`dirname $0`
BASE_DIR="${SCRIPTS_DIR}/.."
DBDUMP_DIR="${BASE_DIR}/dbdump"

sh ${SCRIPTS_DIR}/drop_openmrs_db.sh password
#sh ${SCRIPTS_DIR}/drop_openelis_db.sh
#sh ${SCRIPTS_DIR}/drop_openerp_db.sh