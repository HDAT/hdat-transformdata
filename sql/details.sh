echo "Running Details: SQL 1 cargo Valuta Calc"
psql -d bgb -f $PWD/sql/details/0-cargoValutaCalc.sql

echo "Running Details: SQL 1 Color Coding"
psql -d bgb -f $PWD/sql/details/1-colorCoding.sql

echo "Running Details: SQL 2 Minard"
psql -d bgb -f $PWD/sql/minard/2-minard.sql

echo "Export Minard JSON"
# psql -d bgb -c "copy (select json from \"bgbCargoMinardJSONExport\") to '$PWD/data/json/minard.json';"

echo "Export Places"
# psql -d bgb -c "copy (SELECT concat('{ \"type\": \"FeatureCollection\", \"features\":', array_to_json(array_agg(json)), NULL, '}') FROM \"bgbPlaceGeoJSON\") to '$PWD/data/json/places.json';"

