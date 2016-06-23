#!/bin/sh
set -e -x
dumpfile=$1

if [ -z $dumpfile ]; then
	echo "Please specify sql dump file"
	exit 1
fi	

psql -Upostgres < $dumpfile >/dev/null
psql -Upostgres -c "truncate replication_test;";
