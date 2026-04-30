 WITH step_map AS (
    SELECT *,
           CASE 
               WHEN event_type = 'login' THEN 1
               WHEN event_type = 'view_product' THEN 2
               WHEN event_type = 'add_to_cart' THEN 3
               ELSE 4
           END AS step_no,
           COALESCE(
               TIMESTAMPDIFF(
                   MINUTE,
                   LAG(event_time) OVER (PARTITION BY user_id ORDER BY event_time),
                   event_time
               ), 0
           ) AS gap_min
    FROM events
),

sess_flag AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY event_time) AS rn,
           CASE WHEN gap_min > 30 THEN 1 ELSE 0 END AS new_sess
    FROM step_map
),

sess_breaks AS (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY event_time) AS break_id
    FROM sess_flag
    WHERE new_sess = 1
),

sess_fill AS (
    SELECT f.*,
           IFNULL(
               IFNULL(
                   b.break_id,
                   MIN(b.break_id) OVER (
                       PARTITION BY f.user_id
                       ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
                   ) - 1
               ),
               MAX(b.break_id) OVER (
                   PARTITION BY f.user_id
                   ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
               )
           ) AS sess_id
    FROM sess_flag f
    LEFT JOIN sess_breaks b
        ON f.user_id = b.user_id
       AND f.rn = b.rn
),

step_dedup AS (
    SELECT user_id,
           event_time,
           event_type,
           gap_min,
           step_no,
           IFNULL(sess_id, 0) AS sess_id,
           CASE 
               WHEN step_no - LAG(step_no) OVER (
                        PARTITION BY user_id, sess_id ORDER BY step_no
                    ) = 1
                    OR LAG(step_no) OVER (
                        PARTITION BY user_id, sess_id ORDER BY step_no
                    ) IS NULL
               THEN 0
               ELSE 1
           END AS bad_flow,
           ROW_NUMBER() OVER (
               PARTITION BY user_id, sess_id, event_type
           ) AS rn_ev
    FROM sess_fill
),

step_seq AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY user_id, sess_id ORDER BY event_time
           ) AS step_rank
    FROM step_dedup
    WHERE rn_ev = 1
),

sess_stats AS (
    SELECT *,
           COUNT(*) OVER (PARTITION BY user_id, sess_id) AS step_cnt,
           MAX(bad_flow) OVER (PARTITION BY user_id, sess_id) AS has_issue
    FROM step_seq
)

SELECT 
    user_id,
    ROW_NUMBER() OVER (PARTITION BY user_id) AS session_id,
    CASE 
        WHEN step_cnt = 4 AND has_issue = 0 THEN 'FULL_CONVERSION'
        WHEN step_cnt < 4 AND step_cnt != 1 AND has_issue = 0 THEN 'PARTIAL'
        WHEN step_cnt = 1 AND has_issue = 0 AND event_type = 'login' THEN 'PARTIAL'
        ELSE 'NO_CONVERSION'
    END AS funnel_status
FROM sess_stats
WHERE step_rank = 1;
