DROP TABLE IF EXISTS "bgbCargoMinardSplit";

CREATE TABLE "bgbCargoMinardSplit" (
    cargoid integer,
    cargogeom geometry(geometry, 4326),
    cargonumvoyages bigint,
    cargovalues bigint
);

INSERT INTO "bgbCargoMinardSplit" SELECT (f).cargoId, (f).cargoGeom, (f).cargoNumVoyages, (f).cargoValues
FROM (SELECT minardSegment("carProductId",geom,"numberVoyages","value") AS f FROM "bgbCargoMinardExport") 
	AS x LIMIT 1000;