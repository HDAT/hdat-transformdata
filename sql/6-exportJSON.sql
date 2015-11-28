-- Add a column type with the value feature

ALTER TABLE "bgbVoyageRouteNoDuplicates" 
	ADD COLUMN "type" varchar(255) DEFAULT 'Feature';

-- Fill route with json (for voyages.json)

INSERT INTO "bgbVoyageRouteNoDuplicatesJSON" 
	SELECT row_to_json(t) FROM 
		(SELECT "type", "geometry",
		    (
		      SELECT row_to_json(d)
		      FROM (
		        SELECT time
		      ) d
		    ) AS properties,
		    (
		      SELECT row_to_json(d)
		      FROM (
		        SELECT voynumber, first_ship_name, placeregio, inventory
		      ) d
		    ) AS voyageDetails
	  	-- FROM "bgbVoyageRouteNoDuplicates" WHERE "geometry" IS NOT NULL AND "time" IS NOT NULL ORDER BY "voyDepTimeStamp" ASC) 
	  	FROM "bgbVoyageRouteNoDuplicates" WHERE "geometry" IS NOT NULL AND "time" IS NOT NULL AND "voyDepTimeStamp" BETWEEN '1755-01-01 00:00:00'::timestamp AND '1769-01-10 00:00:00'::timestamp ORDER BY "voyDepTimeStamp" ASC) 
	-- AS t LIMIT 100;
	AS t;

-- Remove temporary type column 

ALTER TABLE "bgbVoyageRouteNoDuplicates" DROP COLUMN "type";
