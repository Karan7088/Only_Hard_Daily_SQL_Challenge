WITH cte AS (
    SELECT 
        a.user_id,
        a.event_time,
        (
            SELECT COUNT(DISTINCT e.product_id)
            FROM events e
            WHERE e.user_id = a.user_id
              AND e.event_time BETWEEN a.event_time 
                                   AND a.event_time + INTERVAL 30 MINUTE
              AND e.event_type = 'cart'
            HAVING COUNT(DISTINCT e.product_id) >= 3
               AND SUM(CASE WHEN e.event_type = 'purchase' THEN 1 ELSE 0 END) = 0
        ) AS cart_count
    FROM events a
)

SELECT 
    user_id,
    MIN(event_time) AS window_start,
    cart_count
FROM cte
WHERE cart_count >= 3
GROUP BY user_id, cart_count;