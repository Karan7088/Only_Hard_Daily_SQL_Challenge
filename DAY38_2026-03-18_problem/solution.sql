 WITH base_events AS (
    SELECT *,
           ROW_NUMBER() OVER() AS row_id,
           CASE 
               WHEN event_type = 'start'  THEN 1
               WHEN event_type = 'pause'  THEN 2
               WHEN event_type = 'resume' THEN 3
               WHEN event_type = 'cancel' THEN 4
               ELSE 0 
           END AS event_seq
    FROM subscriptions_log
),

cancel_markers AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY event_date) AS cancel_group
    FROM base_events
    WHERE event_type = 'cancel'
),

events_with_cancel_tag AS (
    SELECT b.*, c.cancel_group
    FROM base_events b
    LEFT JOIN cancel_markers c 
        ON b.row_id = c.row_id
),

forward_filled_cancel AS (
    SELECT 
        user_id, event_type, event_date, amount, row_id, event_seq,
        IFNULL(
            cancel_group,
            MIN(cancel_group) OVER (
                PARTITION BY user_id 
                ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
            )
        ) AS cancel_group
    FROM events_with_cancel_tag
),

final_cancel_group AS (
    SELECT 
        user_id, event_type, event_date, amount, row_id, event_seq,
        IFNULL(
            cancel_group,
            MAX(cancel_group) OVER (
                PARTITION BY user_id 
                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
            ) + 1
        ) AS cancel_group
    FROM forward_filled_cancel
),

state_tracking AS (
    SELECT *,
           MAX(event_seq) OVER (
               PARTITION BY user_id, cancel_group 
               ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
           ) AS prev_max_seq,

           MIN(event_seq) OVER (
               PARTITION BY user_id, cancel_group 
               ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
           ) AS prev_min_seq
    FROM final_cancel_group
),

event_validation AS (
    SELECT *,
        CASE  

            WHEN event_type = 'start' 
                 AND prev_max_seq IS NULL 
                 OR prev_max_seq = 4 
            THEN 1 

            WHEN event_type = 'renewal' 
                 AND prev_min_seq = 1 
                 AND prev_max_seq != 4 
            THEN 1 

            WHEN event_type = 'pause' 
                 AND prev_max_seq = 1 
                 OR (
                     prev_max_seq = 3 
                     AND (
                         (SELECT COUNT(CASE WHEN event_type = 'pause' THEN 1 END)
                          FROM state_tracking 
                          WHERE cancel_group = a.cancel_group 
                            AND user_id = a.user_id 
                            AND a.row_id <= row_id)
                         =
                         (SELECT COUNT(CASE WHEN event_type = 'resume' THEN 1 END)
                          FROM state_tracking 
                          WHERE cancel_group = a.cancel_group 
                            AND user_id = a.user_id 
                            AND a.row_id <= row_id)
                     )
                 )
            THEN 1 

            WHEN (
                    event_type = 'resume' 
                    AND prev_max_seq = 2
                 )
                 OR (
                    event_type = 'resume' 
                    AND prev_max_seq = 3 
                    AND (
                        (SELECT COUNT(CASE WHEN event_type = 'pause' THEN 1 END)
                         FROM state_tracking 
                         WHERE cancel_group = a.cancel_group 
                           AND user_id = a.user_id 
                           AND row_id <= a.row_id)
                        =
                        (SELECT COUNT(CASE WHEN event_type = 'resume' THEN 1 END)
                         FROM state_tracking 
                         WHERE cancel_group = a.cancel_group 
                           AND user_id = a.user_id 
                           AND row_id <= a.row_id)
                    )
                 )
            THEN 1 

            WHEN event_type = 'cancel' 
                 AND prev_min_seq = 1 
                 OR prev_min_seq = 0 
            THEN 1 

            ELSE 0 
        END AS is_valid_event

    FROM state_tracking a
)

SELECT 
    user_id,
    CASE 
        WHEN MIN(is_valid_event) = 0 THEN 'invalid_user'
        ELSE 'valid_user'
    END AS status
FROM event_validation
GROUP BY user_id;
