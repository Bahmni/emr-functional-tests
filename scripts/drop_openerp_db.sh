#!/bin/sh
set -e -x

psql -Upostgres -c "drop database if exists openerp;";
