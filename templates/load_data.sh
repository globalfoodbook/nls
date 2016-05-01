#!/bin/bash

set -e

export DB_DUMP_LOCATION=/tmp/psql_data/nutrition_sr26_plain.sql

echo -e "*** LOADING DATABASE ***"

# create default database
# gosu postgres $POSTGRES_MAIN_USER --single <<EOSQL
#   CREATE DATABASE "$POSTGRES_DB";
#   GRANT ALL PRIVILEGES ON DATABASE "$POSTGRES_DB" TO postgres;
# EOSQ

# clean sql_dump - because I want to have a one-line command

# remove indentation
sed 's/^[ \t]*//' -i $DB_DUMP_LOCATION

# remove comments
sed '/^--/ d' -i $DB_DUMP_LOCATION

# remove new lines
sed ':a;N;$!ba;s/\n/ /g' -i $DB_DUMP_LOCATION

# remove other spaces
sed 's/  */ /g' -i $DB_DUMP_LOCATION

# remove firsts line spaces
sed 's/^ *//' -i $DB_DUMP_LOCATION

# append new line at the end
sed -e '$a\' -i $DB_DUMP_LOCATION

# Replace role
# sed -i s"/ikennaokpala/$POSTGRES_USER/" $DB_DUMP_LOCATION

# sleep 10
# import sql_dump
exec gosu postgres $POSTGRES_MAIN_USER --single $POSTGRES_DB < $DB_DUMP_LOCATION > /dev/null 2>&1

echo -e "*** DATABASE LOADED! ***"
