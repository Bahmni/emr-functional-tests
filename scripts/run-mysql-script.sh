#!/bin/sh
set -e -x

rootPassword=$1
sqlfile=$2

if [ -z $rootPassword ]; then
    echo "Please provide a password for mysql root"
	echo "[USAGE] $0 <mysqlRootPassword> <sqlDumpFile>"
	exit 1
fi	

if [ -z $sqlfile ]; then
	echo "Please specify sql dump file"
	echo "[USAGE] $0 <mysqlRootPassword> <sqlDumpFile>"
	exit 1
fi

mysql -uroot -p$rootPassword  -e "show databases" | grep -v Database | grep -v mysql| grep -v information_schema| grep -v test | grep -v OLD |gawk '{print "drop database " $1 ";select sleep(0.1);"}' | mysql -uroot -ppassword
mysql -uroot -p$rootPassword < $sqlfile