#!/bin/bash
for i in {996..1000}
do
	psql -d bgb -c "copy (SELECT json_agg(g) FROM (SELECT ST_AsGeoJSON(ST_Union(cargogeom))::json AS geometry, (SELECT row_to_json(d) FROM (SELECT cargoid AS voyageid, voyages, cargovalues) d) AS properties, to_json('Feature'::text) AS type FROM (SELECT cargoid, cargogeom, sum(cargonumvoyages) AS voyages, sum(cargovalues) AS cargovalues FROM \"bgbCargoMinardSplit\" GROUP BY cargoid, cargogeom) AS x WHERE cargoid = $i GROUP BY cargoid, voyages, cargovalues ORDER BY cargoid ) AS g) to '/Users/$USER/Desktop/hdat-transformdata/data/minard/$i.json';"
done