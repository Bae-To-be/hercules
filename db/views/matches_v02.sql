SELECT source_id AS user_id,
       target_id AS matched_user_id,
       id,
       created_at
FROM match_stores
UNION
SELECT target_id AS user_id,
       source_id AS matched_user_id,
       id,
       created_at
FROM match_stores;