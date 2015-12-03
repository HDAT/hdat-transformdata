BLUE='\033[0;34m'
NC='\033[0m' 

#!/bin/bash

echo "${BLUE}Delete table"
psql -d bgb -c "drop schema public cascade;"
psql -d bgb -c "create schema public;"

echo "Import bgb"
psql -d bgb -f $PWD/data/bgb.psql

echo "1,2,3${NC}"
psql -d bgb -c "create extension postgis;"
psql -d bgb -c "create extension pgrouting;"
psql -d bgb -c "create extension postgis_topology;"
psql -d bgb -c "create extension fuzzystrmatch;"
psql -d bgb -c "create extension postgis_tiger_geocoder;"