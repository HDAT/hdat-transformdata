ALTER TABLE "bgbCargo"
	ADD COLUMN value 	integer,
	ADD COLUMN jaar 	integer;

-- Ik heb gekozen voor boekjaar, omdat de enige zekere datum is
-- die we op dit moment hebben.
UPDATE "bgbCargo"
SET jaar = "voyBookingYear"
FROM "bgbVoyage"
WHERE "carVoyageId" = "voyId";

-- Lichte guldens naar guldens pre-1743 20%
UPDATE "bgbCargo"
SET value = round("carValueLichtGuldens"::integer * 0.8)
WHERE jaar BETWEEN 1700 AND 1742;

-- Lichte guldens naar guldens 1743 en 1768 16,35%
UPDATE "bgbCargo"
SET value = round("carValueLichtGuldens"::integer * 0.8365)
WHERE jaar BETWEEN 1743 AND 1768;

-- Voor de overige jaren werden alleen guldens gebruikt
UPDATE "bgbCargo"
SET value = "carValueGuldens"
WHERE jaar BETWEEN 1769 AND 1802;

-- Zware guldens worden opgeteld bij de al omgezette lichte guldens
UPDATE "bgbCargo"
SET value = "carValueGuldens"
WHERE jaar BETWEEN 1700 AND 1768 AND "carValueLichtGuldens" IS NULL;

-- Queries om de kwaliteit te testen
-- "carValueGuldens" IS NOT NULL AND "carValueLichtGuldens" IS NOT NULL
-- "carValueGuldens" IS NOT NULL AND "value" IS NULL
-- Bovenstaande geeft een result. Er is een cargo zonder bijbehorende voyage ...