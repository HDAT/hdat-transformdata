DROP TABLE IF EXISTS "bgbCargoGUI";
CREATE TABLE "bgbCargoGUI" (
	"carProductId"	integer PRIMARY KEY,
	"name"			text,
	"count"			integer,
	"textcount"		text,
	"value"	integer
);

-- Grab  carProductId, group and count them
INSERT INTO "bgbCargoGUI"
SELECT	"carProductId",
		"carProductId" AS name, 
		COUNT("carProductId"),
		COUNT("carProductId"),
		SUM("value")
FROM "bgbCargo" 
GROUP BY "carProductId";

-- Replace naam/id (= carProductId) with the textual name
UPDATE "bgbCargoGUI"
SET name = naam	
FROM "bgbProduct"
WHERE "carProductId" = id;

-- Use textcount for the website
-- This way we can still use count in postgresql to sort
UPDATE "bgbCargoGUI"
SET textcount = count;

UPDATE "bgbCargoGUI"
SET textcount = '< 10'	
WHERE "count" <= 9;
