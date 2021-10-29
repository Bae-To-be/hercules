SELECT source_id AS work_title_id, target_id AS related_work_title_id
FROM work_title_relationships
UNION
SELECT target_id AS work_title_id, source_id AS related_work_title_id
FROM work_title_relationships;