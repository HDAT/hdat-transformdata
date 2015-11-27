#!/bin/bash

echo "Importing route network"
psql -d bgb -c "drop table if exists routing;"
shp2pgsql -c -D -s 4326 -I $PWD/data/map/mapmay.shp routing | psql bgb

echo "Creating functions"
psql -d bgb -f sql/functions/determineRoute.sql
psql -d bgb -f sql/functions/findNearestNode.sql
psql -d bgb -f sql/functions/generateTimeArray.sql

echo "Importing data"
psql -d bgb -f sql/0-createTables.sql
psql -d bgb -c "COPY \"amhPlaces\" FROM '$PWD/data/amh_location_mod.csv' DELIMITER ',' CSV;"

echo "Running Routing"
psql -d bgb -f sql/1-routing.sql

echo "Setting up coordinates to places"
psql -d bgb -f sql/2-coordinates.sql

echo "Running voyagesGeo"
psql -d bgb -f sql/3-voyagesGeo.sql

echo "Running voyagesTime"
psql -d bgb -f sql/4-voyagesTime.sql

echo "Executing the Details shellscript"
sh sql/details.sh

echo "Running JSON export"
psql -d bgb -f sql/5-exportJSON.sql

echo "Export JSON"
psql -d bgb -c "copy (SELECT array_to_json(array_agg(route::json)) from \"bgbVoyageRouteJSON\") to '$PWD/data/json/voyages.json';"

echo "Export Places"
psql -d bgb -c "copy (SELECT concat('{ \"type\": \"FeatureCollection\", \"features\":', array_to_json(array_agg(json)), NULL, '}') FROM \"bgbPlaceGeoJSON\") to '$PWD/data/json/places.json';"

