SELECT to_json(array_agg(d)) FROM (SELECT
    "jaar" AS jaar,
    "value" AS VALUE
FROM "bgbCargoGraph" WHERE "carProductId" = 979 ORDER BY jaar)
AS d