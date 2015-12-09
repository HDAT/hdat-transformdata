echo "Running Products: 0-cargoValutaCal.csql"
psql -d bgb -f $PWD/sql/products/0-cargoValutaCalc.sql

echo "Running Products: 1-colorCoding.sql"
psql -d bgb -f $PWD/sql/products/1-colorCoding.sql

# echo "Export Places"
# psql -d bgb -c "copy (SELECT concat('{ \"type\": \"FeatureCollection\", \"features\":', array_to_json(array_agg(json)), NULL, '}') FROM \"bgbPlaceGeoJSON\") to '$PWD/data/json/places.json';"

