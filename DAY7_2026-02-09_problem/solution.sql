WITH daily_agg AS (
    -- Aggregate CPU per user per day + total CPU per day
    SELECT
        usage_date,
        user_id,
        SUM(cpu_minutes) OVER (PARTITION BY usage_date) AS day_total_cpu,
        SUM(cpu_minutes) OVER (PARTITION BY usage_date, user_id) AS user_day_cpu
    FROM cpu_usage
),

ranked_users AS (
    -- Rank users by CPU usage and calculate cumulative percentage
    SELECT
        usage_date,
        user_id,
        user_day_cpu,
        day_total_cpu,
        ROW_NUMBER() OVER (
            PARTITION BY usage_date
            ORDER BY user_day_cpu DESC, user_id
        ) AS rn,
        SUM(user_day_cpu) OVER (
            PARTITION BY usage_date
            ORDER BY user_day_cpu DESC, user_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) * 100.0 / day_total_cpu AS cum_pct
    FROM daily_agg
    WHERE day_total_cpu > 0
),

upto_80 AS (
    -- Users that stay within 80% boundary
    SELECT
        usage_date,
        user_id,
        rn,
        cum_pct,
        MAX(cum_pct) OVER (PARTITION BY usage_date) AS max_pct,
        MAX(rn) OVER (PARTITION BY usage_date) AS max_rn
    FROM ranked_users
    WHERE cum_pct <= 80.0
)

-- Case 1: Exact or under 80%
SELECT
    usage_date,
    CASE
        WHEN MAX(max_pct) < 80.0 THEN
            CONCAT(
                GROUP_CONCAT(user_id),
                ',',
                (
                    SELECT user_id
                    FROM ranked_users r
                    WHERE r.usage_date = u.usage_date
                      AND r.rn = u.max_rn + 1
                )
            )
        ELSE
            GROUP_CONCAT(user_id)
    END AS users
FROM upto_80 u
GROUP BY usage_date

UNION

-- Case 2: Single user already crosses 80%
SELECT
    usage_date,
    GROUP_CONCAT(user_id) AS users
FROM ranked_users
WHERE rn = 1 AND cum_pct > 80.0
GROUP BY usage_date

ORDER BY usage_date;
