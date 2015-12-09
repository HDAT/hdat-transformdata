#!/bin/bash
for i in {979..5225}
do
	psql -d bgb -c "copy (SELECT to_json(array_agg(d)) FROM (SELECT "jaar" AS jaar, "value" AS VALUE FROM \"bgbCargoGraph\" WHERE \"carProductId\" = $i ORDER BY jaar) AS d) to '/Users/$USER/Desktop/hdat-transformdata/data/export/graph/$i.json';"
	echo 'export graph:' $i;
done