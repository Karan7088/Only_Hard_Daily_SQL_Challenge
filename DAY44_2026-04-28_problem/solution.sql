WITH order_refund_base AS (
    SELECT 
        o.*,
        r.refund_amount,
        r.refund_date
    FROM orders o
    LEFT JOIN refunds r 
        ON o.order_id = r.order_id
       AND r.refund_amount > 0
),

customer_metrics AS (
    SELECT 
        customer_id,

        DATEDIFF(
            LEAD(refund_date) OVER (
                PARTITION BY customer_id 
                ORDER BY refund_date
            ),
            refund_date
        ) AS df,

        COUNT(*) OVER (
            PARTITION BY customer_id
        ) AS total_orders,

        COUNT(
            CASE 
                WHEN refund_amount IS NOT NULL THEN 1 
            END
        ) OVER (
            PARTITION BY customer_id
        ) AS refunded_orders

    FROM order_refund_base
),

consecutive_flag AS (
    SELECT 
        *,
        MIN(df) OVER (
            PARTITION BY customer_id
        ) AS mndf
    FROM customer_metrics
)

SELECT 
    customer_id,
    total_orders,
    refunded_orders,
    refunded_orders / total_orders AS refund_ratio,
    'yes' AS has_consecutive_refunds

FROM consecutive_flag

WHERE 
    mndf = 1
    AND refunded_orders / total_orders >= 0.6

GROUP BY 
    1,2,3,4; 
