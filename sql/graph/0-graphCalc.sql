DROP TABLE IF EXISTS "bgbCargoGraph";
CREATE TABLE "bgbCargoGraph" (
	"carProductId" 	integer,
	"jaar"	 		integer,
	"value" 		integer
);

INSERT INTO "bgbCargoGraph"
SELECT DISTINCT ON ("carProductId", "jaar") "carProductId", "jaar", SUM(value)
FROM "bgbCargo" GROUP BY "jaar", "carProductId";