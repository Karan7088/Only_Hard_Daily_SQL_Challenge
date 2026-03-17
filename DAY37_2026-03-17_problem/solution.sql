 WITH user_base AS (
    SELECT 
        *,
        MIN(activity_date) OVER (PARTITION BY user_id) AS cohort_date,
        MAX(activity_date) OVER (PARTITION BY user_id) AS last_activity,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY activity_date) AS rn
    FROM user_activity
),

cohort_dates AS (
    SELECT DISTINCT activity_date
    FROM user_base
    WHERE rn = 1
),

all_dates AS (
    SELECT DISTINCT activity_date
    FROM user_activity
),

date_grid AS (
    SELECT 
        c.activity_date AS cohort_date,
        d.activity_date AS dt
    FROM cohort_dates c
    CROSS JOIN all_dates d
    WHERE c.activity_date <= d.activity_date
),

retention_calc AS (
    SELECT 
        cohort_date,
        DATEDIFF(dt, cohort_date) AS retention_day,
        CASE 
            WHEN dt != cohort_date THEN (
                SELECT COUNT(DISTINCT user_id)
                FROM user_base
                WHERE cohort_date = retention_calc.cohort_date
                  AND user_base.activity_date = retention_calc.dt
            )
            ELSE (
                SELECT COUNT(DISTINCT user_id)
                FROM user_base
                WHERE cohort_date = retention_calc.cohort_date
            )
        END AS users
    FROM date_grid retention_calc
)

SELECT *
FROM retention_calc
WHERE users != 0
ORDER BY cohort_date, retention_day;
