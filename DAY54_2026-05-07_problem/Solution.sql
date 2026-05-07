WITH base_activity AS (
    SELECT *,
           ABS(
               DATEDIFF(
                   MIN(order_time) OVER (PARTITION BY driver_id),
                   order_time
               )
           ) AS days_diff,

           FLOOR(
               ABS(
                   DATEDIFF(
                       MIN(order_time) OVER (PARTITION BY driver_id),
                       order_time
                   )
               ) / 7
           ) AS rolling_group,

           TIMESTAMPDIFF(
               MINUTE,
               order_time,
               delivery_time
           ) AS delivery_minutes

    FROM delivery_orders
    ORDER BY driver_id, order_time
),

window_bounds AS (
    SELECT *,
           MIN(order_time) OVER (
               PARTITION BY driver_id, rolling_group
           ) AS raw_window_start,

           MAX(order_time) OVER (
               PARTITION BY driver_id, rolling_group
           ) AS window_end,

           DENSE_RANK() OVER (
               PARTITION BY driver_id
               ORDER BY rolling_group
           ) AS window_rank

    FROM base_activity
),

adjusted_windows AS (
    SELECT *,
           CASE
               WHEN window_rank = 1
               THEN raw_window_start
               ELSE DATE_SUB(window_end, INTERVAL 7 DAY)
           END AS window_start

    FROM window_bounds
),

window_groups AS (
    SELECT *,
           DENSE_RANK() OVER (
               PARTITION BY driver_id
               ORDER BY window_start
           ) AS window_group_id

    FROM adjusted_windows
),

window_metrics AS (
    SELECT *,

           (
               SELECT COUNT(DISTINCT customer_id)
               FROM window_groups
               WHERE order_time BETWEEN a.window_start AND a.window_end
                 AND driver_id = a.driver_id
           ) AS distinct_customers,

           (
               SELECT COUNT(*)
               FROM window_groups
               WHERE DATE(order_time)
                     BETWEEN DATE(a.window_start)
                     AND DATE(a.window_end)
                 AND a.driver_id = driver_id
           ) AS total_orders,

           (
               SELECT COUNT(*)
               FROM window_groups
               WHERE delivery_minutes > 10
                 AND DATE(order_time)
                     BETWEEN DATE(a.window_start)
                     AND DATE(a.window_end)
                 AND driver_id = a.driver_id
           ) AS slow_deliveries

    FROM window_groups a
),

fraud_metrics AS (
    SELECT *,

           (
               (total_orders - distinct_customers)
               / total_orders
           ) * 100.0 AS repeat_customer_pct,

           (
               (total_orders - slow_deliveries)
               / total_orders
           ) * 100.0 AS fast_delivery_pct

    FROM window_metrics
)

SELECT
    driver_id,
    window_start,
    window_end,
    total_orders,
    distinct_customers,

    MAX(fast_delivery_pct) AS fast_delivery_pct,

    MAX(repeat_customer_pct) AS repeat_customer_pct,

    MAX(
        CASE
            WHEN fast_delivery_pct >= 70
             AND repeat_customer_pct >= 60
            THEN 'SUSPICIOUS'
            ELSE 'NORMAL'
        END
    ) AS result

FROM fraud_metrics

WHERE window_start != window_end

GROUP BY
    1, 2, 3, 4, 5

ORDER BY
    1, 2;
