WITH inter_base AS (
    SELECT 
        CASE WHEN user_id < friend_id THEN user_id ELSE friend_id END AS user_id,
        CASE WHEN user_id < friend_id THEN friend_id ELSE user_id END AS friend_id,
        interaction_count
    FROM interactions
    GROUP BY 1,2,3
),

mutual_join AS (
    SELECT 
        a.*,
        b.user_id AS mid_user,
        b.friend_id AS rec_user,
        b.interaction_count AS rec_cnt
    FROM inter_base a
    CROSS JOIN inter_base b
    WHERE a.friend_id = b.user_id
      AND a.interaction_count >= 3
      AND b.interaction_count >= 3
    ORDER BY 1,2
),

candidate_pairs AS (
    SELECT *
    FROM mutual_join
    WHERE user_id != rec_user
      AND (user_id, rec_user) NOT IN (
            SELECT user_id, friend_id 
            FROM inter_base
      )
)

SELECT 
    CASE WHEN user_id < rec_user THEN user_id ELSE rec_user END AS user1,
    CASE WHEN user_id < rec_user THEN rec_user ELSE user_id END AS user2,
    COUNT(*) AS mutual_frnd
FROM candidate_pairs
GROUP BY 1,2;