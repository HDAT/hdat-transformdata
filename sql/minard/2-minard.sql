-- Stuff for the Minard Diagram

CREATE TEMPORARY TABLE "bgbCargoMinard" AS TABLE "bgbCargo";

ALTER TABLE "bgbCargoMinard" 
	ADD COLUMN "line" geometry(linestring, 4326);

-- Add the existing routes from another table

UPDATE "bgbCargoMinard" SET 
	"line"	= "route"
FROM "bgbVoyageRoute"
WHERE "voyId" = "carVoyageId";

DROP TABLE IF EXISTS "bgbCargoMinardExport";
CREATE TABLE "bgbCargoMinardExport" AS
	SELECT 	"carProductId", 
			ST_AsGeoJSON("line")::json AS geometry, 
			line AS geom, 
			count("carProductId") AS "numberVoyages", 
			sum("value") AS "value"
	FROM "bgbCargoMinard" 
		GROUP BY "carProductId", "line" 
		ORDER BY "carProductId";

ALTER TABLE "bgbCargoMinardExport"
	ADD COLUMN "type" varchar(255) DEFAULT 'Feature';




-- Fill route with json
CREATE TEMPORARY TABLE "bgbCargoMinardJSON" (
	type			varchar(255),
	carproductid	integer,
	properties 		json,
	geometry		json
);

INSERT INTO "bgbCargoMinardJSON" 
		(SELECT "type", "carProductId", (SELECT row_to_json(d) FROM (SELECT "numberVoyages", "value", "carProductId") d) AS properties, "geometry" 
	  	-- FROM "bgbCargoMinardExport" LIMIT 200);
	  	FROM "bgbCargoMinardExport");

DROP TABLE IF EXISTS "bgbCargoMinardJSONExport";
CREATE TABLE "bgbCargoMinardJSONExport" (
	json text
);

-- This aggregates the existing objects inside an array
INSERT INTO "bgbCargoMinardJSONExport" 
SELECT json_object(array_agg(carProductId)::text[],array_agg(rw)::text[])
	FROM ( SELECT carProductId, 
			( SELECT to_json(array_agg(row_to_json(t)))
               FROM ( SELECT type, properties, geometry FROM "bgbCargoMinardJSON" WHERE carProductId=b.carProductId) t ) rw
      FROM "bgbCargoMinardJSON" b
      GROUP BY carProductId ) z;


-- Ik weet dat dit een slechte oplossing is
-- Maar in dit geval heiligt het doel de middelen.
UPDATE "bgbCargoMinardJSONExport" SET json = replace(json, '"[', '[')::text;
UPDATE "bgbCargoMinardJSONExport" SET json = replace(json, ']"', ']')::text;
UPDATE "bgbCargoMinardJSONExport" SET json = replace(json, '\"', '"')::text;

-- Remove temporary type column 
ALTER TABLE "bgbCargoMinardExport" DROP COLUMN "type";	
