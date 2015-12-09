# 26 november 2015
# Dit moet beter gedaan worden. Alles in een array, en vervolgens als JSON exporteren

# psql -d bgb -c "copy (SELECT json_agg(row_to_json(t)) FROM (SELECT \"carProductId\", \"name\", \"textcount\" FROM \"bgbCargoGUI\" WHERE name ILIKE 'a%' ORDER BY name ASC) AS t) to '/Users/$USER/Desktop/HDAT/src/data/json/minardgui/a.json';"


