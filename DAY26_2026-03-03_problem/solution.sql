WITH cte AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY user_id 
            ORDER BY activity_date
        ) AS rn,
        IFNULL(
            DATEDIFF(
                activity_date,
                LAG(activity_date) OVER (
                    PARTITION BY user_id 
                    ORDER BY activity_date
                )
            ),
            1
        ) AS df
    FROM user_activity
),

cte2 AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY user_id 
            ORDER BY activity_date
        ) AS rn2
    FROM cte
    WHERE df != 1
),

cte3 AS (
    SELECT 
        cte.*,
        IFNULL(
            IFNULL(
                cte2.rn2,
                MIN(cte2.rn2) OVER (
                    PARTITION BY cte.user_id 
                    ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
                ) - 1
            ),
            -1
        ) AS rn2
    FROM cte
    LEFT JOIN cte2 
        ON cte.user_id = cte2.user_id
       AND cte.rn = cte2.rn
),

cte4 AS (
    SELECT 
        *,
        COUNT(*) OVER (
            PARTITION BY user_id, rn2
        ) AS streak
    FROM cte3
),

cte5 AS (
    SELECT 
        *,
        DENSE_RANK() OVER (
            PARTITION BY user_id 
            ORDER BY streak DESC, rn2 ASC
        ) AS rnk
    FROM cte4
)

SELECT 
    user_id,
    MIN(activity_date) AS st,
    MAX(activity_date) AS ed,
    MAX(streak) AS streak
FROM cte5
WHERE rnk = 1
GROUP BY user_id
ORDER BY streak DESC, user_id ASC;