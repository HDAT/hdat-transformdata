-- Stuff for the Minard Diagram

CREATE TEMPORARY TABLE "bgbCargoMinard" AS TABLE "bgbCargo";

ALTER TABLE "bgbCargoMinard" 
	ADD COLUMN "line" geometry(multilinestring, 4326);

-- Add the existing routes from another table

UPDATE "bgbCargoMinard" SET 
	"line"	= "trueTemp"
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

-- ALTER TABLE "bgbCargoMinardExport"
-- 	ADD COLUMN "type" varchar(255) DEFAULT 'Feature';

