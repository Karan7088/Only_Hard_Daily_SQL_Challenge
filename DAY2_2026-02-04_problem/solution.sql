-- ============================================
-- PROBLEM 2: CUSTOMER LIFETIME VALUE
-- ============================================

WITH cte AS (
    SELECT 
        o.customer_id,
        c.country,
        o.order_date,
        o.order_amount,
        o.discount_amount,
        o.order_amount - o.discount_amount AS net_revenue,
        (o.order_amount - o.discount_amount) / o.order_amount AS discount_adjustment,
        EXP(-0.1 * TIMESTAMPDIFF(MONTH, 
            MIN(o.order_date) OVER(PARTITION BY o.customer_id), 
            o.order_date)) AS time_decay,
        DATEDIFF(CURDATE(), MAX(o.order_date) OVER(PARTITION BY o.customer_id)) AS last_purc_diff,
        COUNT(*) OVER(PARTITION BY o.customer_id) AS total_orders
    FROM customers c
    INNER JOIN orders o ON o.customer_id = c.customer_id
    WHERE o.status = 'completed'
      AND o.order_amount > 0
),
ltv_calc AS (
    SELECT 
        customer_id,
        country,
        MAX(total_orders) AS total_orders,
        SUM(net_revenue) AS net_revenue,
        ROUND(SUM(order_amount * discount_adjustment * time_decay), 2) AS ltv,
        MAX(last_purc_diff) AS last_purc_diff,
        CASE 
            WHEN SUM(order_amount * discount_adjustment * time_decay) > 500 THEN 'High'
            WHEN SUM(order_amount * discount_adjustment * time_decay) BETWEEN 100 AND 500 THEN 'Medium'
            ELSE 'Low'
        END AS segment,
        CASE WHEN MAX(last_purc_diff) > 90 THEN 1 ELSE 0 END AS at_risk_flag
    FROM cte
    GROUP BY customer_id, country
)
SELECT * FROM ltv_calc;