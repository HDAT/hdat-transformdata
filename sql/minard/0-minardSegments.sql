DROP FUNCTION minardSegment(integer, geometry, bigint, bigint);

CREATE OR REPLACE FUNCTION minardSegment(
		IN carProductId 	integer,
        IN geomProduct 		geometry(geometry, 4326),
        IN numberVoyages 	bigint,
        IN cargoValue 		bigint
    )
    RETURNS TABLE (
    	cargoId integer, 
    	cargoGeom geometry(geometry, 4326), 
    	cargoNumVoyages bigint, 
    	cargoValues bigint
    ) AS
$$

DECLARE
	iterator		decimal	 					:= 1;
	routingGeom		geometry(geometry, 4326) 	;
	remainder		decimal						;

BEGIN
	WHILE iterator < ((SELECT COUNT(*) FROM routing))
	LOOP
		SELECT geom INTO routingGeom FROM routing LIMIT 1 OFFSET floor(iterator);
		remainder = (iterator % 1::decimal);
		-- RAISE NOTICE 'iterator draait (%)', iterator;

		-- RAISE NOTICE '(%)', ST_Covers(geomProduct,routingGeom);
		-- IF(iterator = 1) THEN
			-- RAISE NOTICE '-----------------------------------';
		-- END IF;
		
		IF(remainder = 0.5) THEN
			SELECT geom INTO routingGeom FROM routing LIMIT 1 OFFSET floor(iterator);
		ELSE
			SELECT ST_Reverse(geom) INTO routingGeom FROM routing LIMIT 1 OFFSET floor(iterator);			
		END IF;
		
		IF(ST_Contains(ST_GeomFromText(ST_AsText(geomProduct)), ST_GeomFromText(ST_AsText(routingGeom)))) THEN	
		    	cargoId := carProductId ; 
		    	cargoGeom := routingGeom ;
		    	cargoNumVoyages := numberVoyages ;
		    	cargoValues := cargoValue ;
		        RETURN NEXT;
		    
		ELSE
		END IF;

        iterator := iterator + 0.5;
    END LOOP;
    RETURN;

END;
$$  LANGUAGE plpgsql;


-- SELECT minardSegment('979','0102000020E61000000B000000B81E85EB511059400E2DB29DEFA7F6BF52B81E85EB215940DD240681954300C062105839B4285940F4FDD478E92602C0CBA145B6F32D59404C37894160E502C0941804560EB55940560E2DB29DEF12C07B14AE47E12A5A407D3F355EBA4918C09CC420B072785A40AC1C5A643B5F17C0A01A2FDD24865A40D7A3703D0A5717C0AC1C5A643B975A40B29DEFA7C64B17C004560E2DB2A55A40C3F5285C8F4217C06DE7FBA9F1C25A40C976BE9F1A2F17C0', '2', '2');