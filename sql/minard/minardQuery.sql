DROP TABLE IF EXISTS "bgbCargoMinardSplit";

CREATE TABLE "bgbCargoMinardSplit" (
    cargoid integer,
    cargogeom geometry(geometry, 4326),
    cargonumvoyages bigint,
    cargovalues bigint
);

INSERT INTO "bgbCargoMinardSplit" SELECT (f).cargoId, (f).cargoGeom, (f).cargoNumVoyages, (f).cargoValues
FROM (SELECT minardSegment("carProductId",geom,"numberVoyages","value") AS f FROM "bgbCargoMinardExport") 
	AS x LIMIT 500000;


-- Verdere grouping

SELECT json_agg(g) FROM (SELECT  
		(SELECT row_to_json(e) FROM 
			(SELECT ST_AsGeoJSON(ST_Union(cargogeom))::json AS geometry, 
			(SELECT row_to_json(d) FROM (SELECT cargoid AS voyageid, voyages, cargovalues) d) AS properties,
			to_json('Feature'::text) AS type) e)
	FROM (SELECT 
			cargoid, 
			cargogeom, 
			sum(cargonumvoyages) AS voyages, 
			sum(cargovalues) AS cargovalues
		FROM "bgbCargoMinardSplit" 
		GROUP BY cargoid, cargogeom) 
	AS x 
	WHERE cargoid = 1000
	GROUP BY cargoid, voyages, cargovalues 
	ORDER BY cargoid ) AS g;


-- 100% werkende backup
-- SELECT to_json(array_agg(g)) FROM (SELECT  
-- 			ST_AsGeoJSON(ST_Union(cargogeom))::json AS geometry,
-- 			(SELECT row_to_json(d) FROM (SELECT cargoid AS voyageid, voyages, cargovalues) d) AS property,
-- 			to_json('Feature'::text)
-- 	FROM (SELECT 
-- 			cargoid, 
-- 			cargogeom, 
-- 			sum(cargonumvoyages) AS voyages, 
-- 			sum(cargovalues) AS cargovalues
-- 		FROM "bgbCargoMinardSplit" 
-- 		GROUP BY cargoid, cargogeom) 
-- 	AS x 
-- 	WHERE cargoid = 1000
-- 	GROUP BY cargoid, voyages, cargovalues 
-- 	ORDER BY cargoid ) AS g;

