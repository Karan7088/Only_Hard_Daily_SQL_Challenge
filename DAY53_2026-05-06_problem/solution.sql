 WITH RECURSIVE user_date_range AS (
    
    SELECT 
        user_id,
        MIN(activity_date) AS dt,
        MAX(activity_date) AS mx
    FROM user_activity
    GROUP BY 1

    UNION

    SELECT
        user_id,
        DATE_ADD(dt, INTERVAL 1 DAY) AS dt,
        mx
    FROM user_date_range
    WHERE DATE_ADD(dt, INTERVAL 1 DAY) <= mx
),

deduplicated_activity AS (

    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY user_id, activity_date
        ) AS dedup
    FROM user_activity
),

calendar_activity_map AS (

    SELECT
        user_date_range.*,
        deduplicated_activity.activity_date,
        IFNULL(deduplicated_activity.dedup, 1) AS dedup
    FROM user_date_range
    LEFT JOIN deduplicated_activity
        ON user_date_range.user_id = deduplicated_activity.user_id
       AND user_date_range.dt = deduplicated_activity.activity_date
),

activity_gap_grouping AS (

    SELECT
        *,
        DATE_SUB(
            dt,
            INTERVAL ROW_NUMBER() OVER (
                PARTITION BY user_id
                ORDER BY dt
            ) DAY
        ) AS st
    FROM calendar_activity_map
    WHERE activity_date IS NULL

    UNION ALL

    SELECT
        *,
        DATE_SUB(
            dt,
            INTERVAL ROW_NUMBER() OVER (
                PARTITION BY user_id
                ORDER BY dt
            ) DAY
        ) AS st
    FROM calendar_activity_map
    WHERE activity_date IS NOT NULL
    ORDER BY 1, 2
),

activity_gap_analysis AS (

    SELECT
        *,
        CASE
            WHEN activity_date IS NOT NULL THEN
                IFNULL(
                    DATEDIFF(
                        activity_date,
                        LAG(activity_date) OVER (
                            PARTITION BY user_id
                            ORDER BY activity_date
                        )
                    ),
                    1
                )
            ELSE NULL
        END AS lg_df
    FROM activity_gap_grouping
    ORDER BY 1, 2
),

streak_boundary_detection AS (

    SELECT
        user_id,
        activity_date,
        dt,
        st,
        lg_df,

        MIN(dt) OVER (
            PARTITION BY user_id, st
        ) AS mn,

        MAX(dt) OVER (
            PARTITION BY user_id, st
        ) AS mxx,

        DENSE_RANK() OVER (
            PARTITION BY user_id
            ORDER BY st
        ) AS rnk,

        ROW_NUMBER() OVER (
            PARTITION BY user_id, st
        ) AS rn,

        COUNT(
            CASE
                WHEN activity_date IS NULL THEN 1
            END
        ) OVER (
            PARTITION BY user_id, st
        ) AS null_cnt

    FROM activity_gap_analysis
),

streak_classification_base AS (

    SELECT
        *,

        LEAD(lg_df) OVER (
            PARTITION BY user_id
            ORDER BY rnk
        ) AS ld_df,

        LAG(activity_date) OVER (
            PARTITION BY user_id
            ORDER BY st
        ) AS lg,

        LEAD(activity_date) OVER (
            PARTITION BY user_id
            ORDER BY st
        ) AS ld,

        DATEDIFF(mxx, mn) + 1 AS stk_len

    FROM streak_boundary_detection
    WHERE rn = 1
),

final_phase_metrics AS (

    SELECT
        *,

        ROW_NUMBER() OVER (
            PARTITION BY user_id, dt
        ) AS dup,

        LAG(stk_len) OVER (
            PARTITION BY user_id
            ORDER BY dt
        ) AS prev_stk,

        LEAD(stk_len) OVER (
            PARTITION BY user_id
            ORDER BY dt
        ) AS next_stk

    FROM streak_classification_base
)

SELECT
    user_id,
    mn AS phase_start,
    mxx AS phase_end,

    CASE

        -- Initial activity block
        WHEN rnk = 1
        THEN 'active'

        -- Complete inactivity period
        WHEN null_cnt = stk_len
        THEN 'churn'

        -- Short active comeback between long churn periods
        WHEN prev_stk >= 7
             AND next_stk >= 7
             AND stk_len <= 3
             AND (mn != mxx)
             AND null_cnt = 0
        THEN 'SILENT_RETURN'

        -- Long-term return after churn
        WHEN prev_stk >= 7
             AND stk_len >= 5
             AND null_cnt = 0
        THEN 'TRUE_RESURRECTION'

        -- Default active state
        ELSE 'ACTIVE'

    END AS phase_type

FROM final_phase_metrics

WHERE NOT (
            null_cnt > 0
        AND null_cnt < 7
      )
  AND dup = 1

ORDER BY 1;
