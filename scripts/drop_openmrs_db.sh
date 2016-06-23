#!/bin/sh
set -e -x

rootPassword=$1

if [ -z $rootPassword ]; then
    echo "Please provide a password for mysql root"
	echo "[USAGE] $0 <mysqlRootPassword> <sqlDumpFile>"
	exit 1
fi

mysql -uroot -p$rootPassword  -e "show databases" | grep -v Database | grep -v mysql| grep -v information_schema| grep -v test | grep -v OLD |gawk '{print "drop database " $1 ";select sleep(0.1);"}' | mysql -uroot -p$rootPassword