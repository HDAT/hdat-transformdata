-- Assign Coordinates to places in bgbPlaces

DROP TABLE IF EXISTS "amhPlaces";
CREATE TABLE "amhPlaces" (
	title 			varchar(255),
	record_type 	varchar(255),
	latitude 		varchar(255),
	longitude 		varchar(255)
);

DROP TABLE IF EXISTS "routingMod";
CREATE TABLE "routingMod" AS
  TABLE "routing";

DROP TABLE IF EXISTS "bgbPlaceGeo";
CREATE TABLE "bgbPlaceGeo" AS
  TABLE "bgbPlace";

DROP TABLE IF EXISTS "bgbRegioGeo";
CREATE TABLE "bgbRegioGeo" AS
  TABLE "bgbRegio";  

DROP TABLE IF EXISTS "bgbVoyageRoute";
CREATE TABLE "bgbVoyageRoute" AS
  TABLE "bgbVoyage";

DROP TABLE IF EXISTS "bgbCargoMod";
CREATE TABLE "bgbCargoMod" (
	id 				serial,
	carvoyageid 	integer,
	carinventory 	json
);

DROP TABLE IF EXISTS "bgbVoyageRouteNoDuplicates";
CREATE TABLE "bgbVoyageRouteNoDuplicates" (
	voynumber 			integer,
	first_ship_name 	varchar(255),
	placeregio	 		varchar(255),
	inventory	 		json,
	time				json,
	geometry			json,
	length				integer,
	"VoyDASNumber"		bpchar,
	"voyDepTimeStamp"	timestamp
);

-- Tables that are needed for JSON export
DROP TABLE IF EXISTS "bgbVoyageRouteNoDuplicatesJSON";
CREATE TABLE "bgbVoyageRouteNoDuplicatesJSON" (
	route 	json 
);

DROP TABLE IF EXISTS "bgbPlaceGeoJSON";
CREATE TABLE "bgbPlaceGeoJSON" (
	json 	json 
);

