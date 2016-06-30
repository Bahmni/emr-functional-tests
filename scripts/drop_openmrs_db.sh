#!/bin/sh
set -e -x

rootPassword=$1

if [ -z $rootPassword ]; then
    echo "Please provide a password for mysql root"
	echo "[USAGE] $0 <mysqlRootPassword> <sqlDumpFile>"
	exit 1
fi

mysql -uroot -p$rootPassword  -e "DROP DATABASE IF EXISTS openmrs"