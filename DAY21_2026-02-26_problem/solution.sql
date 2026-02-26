WITH cte AS (
    SELECT 
        *,
        IFNULL(
            TIMESTAMPDIFF(
                MINUTE,
                LAG(login_time) OVER (
                    PARTITION BY user_id 
                    ORDER BY login_time
                ),
                login_time
            ),
            0
        ) AS time_diff
    FROM user
),

cte2 AS (
    SELECT 
        *,
        IFNULL(
            SUM(time_diff) OVER (
                PARTITION BY user_id 
                ORDER BY login_time
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ),
            0
        ) AS sm
    FROM cte
),

cte3 AS (
    SELECT 
        user_id,
        COUNT(DISTINCT ip_address) AS distinct_ips
    FROM cte2
    WHERE sm <= 10
    GROUP BY user_id
),

cte4 AS (
    SELECT 
        c2.*,
        c3.distinct_ips,
        COUNT(*) OVER (PARTITION BY c2.user_id) AS total_logins
    FROM cte2 c2
    INNER JOIN cte3 c3 
        ON c2.user_id = c3.user_id
    WHERE c2.sm <= 10
)

SELECT 
    user_id,
    total_logins,
    distinct_ips,
    MIN(login_time) AS cluster_start_time,
    MAX(login_time) AS cluster_end_time
FROM cte4
WHERE total_logins >= 3
  AND distinct_ips >= 3
GROUP BY 
    user_id,
    total_logins,
    distinct_ips
ORDER BY 
    user_id,
    cluster_start_time;