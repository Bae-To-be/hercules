SELECT source_id AS industry_id, target_id AS related_industry_id
FROM industry_relationships
UNION
SELECT target_id AS industry_id, source_id AS related_industry_id
FROM industry_relationships;