SELECT source_id AS course_id, target_id AS related_course_id
FROM course_relationships
UNION
SELECT target_id AS course_id, source_id AS related_course_id
FROM course_relationships;