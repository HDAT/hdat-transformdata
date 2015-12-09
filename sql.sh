#!/bin/bash

echo "Importing route network"
psql -d bgb -c "drop table if exists routing;"
shp2pgsql -c -D -s 4326 -I $PWD/data/source/map/mapmay.shp routing | psql bgb

echo "Creating functions"
psql -d bgb -f sql/routing/functions/determineRoute.sql
psql -d bgb -f sql/routing/functions/findNearestNode.sql
psql -d bgb -f sql/routing/functions/generateTimeArray.sql

echo "Importing data"
psql -d bgb -f sql/routing/0-createTables.sql
PURPLE='\033[0;35m'
NC='\033[0m' 

psql -d bgb -c "COPY \"amhPlaces\" FROM '$PWD/data/source/amh_location_mod.csv' DELIMITER ',' CSV;"

echo "${PURPLE}Running Routing"
psql -d bgb -f sql/routing/1-routing.sql

echo "Setting up coordinates to places"
psql -d bgb -f sql/routing/2-coordinates.sql

echo "Running voyagesGeo"
psql -d bgb -f sql/routing/3-voyagesGeo.sql

echo "Running voyagesTime"
psql -d bgb -f sql/routing/4-voyagesTime.sql

echo "Executing the Details shellscript"
sh products.sh

echo "Running DAS Duplicates"
psql -d bgb -f sql/routing/5-removeDuplicateDAS.sql

echo "Running JSON export"
psql -d bgb -f sql/routing/6-exportJSON.sql

echo "Export JSON"
psql -d bgb -c "copy (SELECT array_to_json(array_agg(route::json)) from \"bgbVoyageRouteNoDuplicatesJSON\") to '/Users/$USER/Desktop/hdat-transformdata/data/export/voyages.json';"

echo "Export Places${NC}"
psql -d bgb -c "copy (SELECT concat('{ \"type\": \"FeatureCollection\", \"features\":', array_to_json(array_agg(json)), NULL, '}') FROM \"bgbPlaceGeoJSON\") to '$PWD/data/json/places.json';"

