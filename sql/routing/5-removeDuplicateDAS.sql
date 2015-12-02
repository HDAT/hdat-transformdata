-- Opschonen van de BGB
-- Whitespace wordt omgezet naar nulls
UPDATE "bgbVoyageRoute" SET 
	"voyDASNumber" = NULL 
WHERE "voyDASNumber" = '';

-- Removes 2382 duplicates
-- De langste blijft altijd over
INSERT INTO "bgbVoyageRouteNoDuplicates" (voynumber, first_ship_name, placeregio, inventory, time, geometry, "VoyDASNumber", length, "voyDepTimeStamp")
SELECT DISTINCT ON ("voyDASNumber") voynumber, first_ship_name, placeregio, inventory, time, geometry, "voyDASNumber", length, "voyDepTimeStamp"
    FROM "bgbVoyageRoute"
    ORDER BY "voyDASNumber", length DESC;

-- Insert de overige 13049 voyages
INSERT INTO "bgbVoyageRouteNoDuplicates" (voynumber, first_ship_name, placeregio, inventory, time, geometry, "VoyDASNumber", length, "voyDepTimeStamp")
SELECT voynumber, first_ship_name, placeregio, inventory, time, geometry, "voyDASNumber", length, "voyDepTimeStamp"
    FROM "bgbVoyageRoute"
    WHERE "voyDASNumber" IS NULL;