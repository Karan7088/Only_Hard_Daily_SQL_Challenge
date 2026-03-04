WITH cte AS (
    SELECT *,
           CASE 
               WHEN status = 'completed' THEN 1 
               ELSE -1 
           END AS st,
           ROW_NUMBER() OVER (
               PARTITION BY user_id
           ) AS rn
    FROM orders
),

cte2 AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY user_id 
               ORDER BY order_datetime
           ) AS comp_rn
    FROM cte
    WHERE status = 'completed'
),

cte3 AS (
    SELECT 
        cte.*,
        IFNULL(
            cte2.comp_rn,
            MAX(comp_rn) OVER (
                PARTITION BY user_id 
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            )
        ) AS comp_rn
    FROM cte
    LEFT JOIN cte2
        ON cte.rn = cte2.rn
       AND cte.user_id = cte2.user_id
),

cte4 AS (
    SELECT *,
           SUM(st) OVER (
               PARTITION BY user_id, comp_rn
               ORDER BY user_id, order_datetime
               ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
           ) AS sm
    FROM cte3
    WHERE comp_rn IS NOT NULL
),

cte5 AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY user_id, DATE(order_datetime)
           ) AS rn3
    FROM cte4
    WHERE sm > 0
),

cte6 AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY user_id
           ) AS rn4,
           TIMESTAMPDIFF(
               DAY,
               LAG(order_datetime) OVER (
                   PARTITION BY user_id 
                   ORDER BY order_datetime
               ),
               order_datetime
           ) AS df
    FROM cte5
    WHERE rn3 = 1
)

SELECT 
    user_id,

    (SELECT order_datetime 
     FROM cte6 
     WHERE a.user_id = user_id AND rn4 = 1) AS first,

    (SELECT order_datetime 
     FROM cte6 
     WHERE a.user_id = user_id AND rn4 = 2) AS second,

    DATEDIFF(
        (SELECT order_datetime 
         FROM cte6 
         WHERE a.user_id = user_id AND rn4 = 2),

        (SELECT order_datetime 
         FROM cte6 
         WHERE a.user_id = user_id AND rn4 = 1)
    ) AS day_diff

FROM cte6 a
WHERE rn4 <= 2
GROUP BY 1, 2, 3, 4;