 WITH distinct_months AS (
    SELECT DISTINCT 
        DATE_FORMAT(activity_date, '%Y-%m') AS activity_month
    FROM user_activity
),

user_month_grid AS (
    SELECT 
        dm.activity_month,
        ua.user_id
    FROM distinct_months dm
    CROSS JOIN user_activity ua
    GROUP BY 1, 2
    ORDER BY 2, 1
),

activity_mapping AS (
    SELECT 
        ROW_NUMBER() OVER (PARTITION BY umg.activity_month, umg.user_id) AS row_num,
        umg.activity_month,
        umg.user_id,
        DATE_FORMAT(u.activity_date, '%Y-%m') AS active_month
    FROM user_month_grid umg
    LEFT JOIN user_activity u 
        ON DATE_FORMAT(u.activity_date, '%Y-%m') = umg.activity_month
       AND umg.user_id = u.user_id
),

user_timeline AS (
    SELECT 
        activity_month,
        user_id,
        active_month,
        LAG(active_month) OVER (PARTITION BY user_id ORDER BY activity_month) AS prev_month_activity,
        MAX(active_month) OVER (
            PARTITION BY user_id 
            ORDER BY activity_month 
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ) AS any_past_activity
    FROM activity_mapping
    WHERE row_num = 1
    ORDER BY 2, 1
),

final_status AS (
    SELECT 
        activity_month,
        user_id,
        CASE 
            WHEN prev_month_activity IS NULL 
                 AND active_month IS NOT NULL 
                 AND any_past_activity IS NULL 
                THEN 'NEW'

            WHEN (prev_month_activity IS NOT NULL AND active_month IS NULL) 
              OR (prev_month_activity IS NULL AND active_month IS NULL AND any_past_activity IS NOT NULL) 
                THEN 'CHURNED'

            WHEN prev_month_activity IS NOT NULL 
                 AND active_month IS NOT NULL 
                THEN 'RETAINED'

            WHEN active_month IS NOT NULL 
                 AND prev_month_activity IS NULL 
                 AND any_past_activity IS NOT NULL 
                THEN 'RESURRECTED'
        END AS status
    FROM user_timeline
    ORDER BY 2, 1
)

SELECT *
FROM final_status
WHERE status != '';
