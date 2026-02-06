-- ============================================
-- PROBLEM 4: MOVING METRICS WITH GAPS
-- ============================================

WITH cte AS (
    SELECT 
        o.customer_id,
        o.order_id,
        o.order_date,
        o.order_amount,
        o.discount_amount,
        ot.product_category,
        ROW_NUMBER() OVER (PARTITION BY o.customer_id ORDER BY o.order_date) AS rn
    FROM orders o
    LEFT JOIN order_items ot ON ot.order_id = o.order_id
    WHERE o.status = 'completed' 
      AND o.order_amount > 0
)
SELECT 
    customer_id,
    order_id,
    order_date,
    order_amount,
    
    -- Rolling 3-order average
    ROUND(AVG(order_amount) OVER (
        PARTITION BY customer_id 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS rolling_3avg,
    
    -- Days since previous order
    DATEDIFF(order_date, LAG(order_date) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date
    )) AS days_since_prev_order,
    
    -- Cumulative distinct categories
    (SELECT COUNT(DISTINCT product_category) 
     FROM cte c2 
     WHERE c2.customer_id = cte.customer_id 
       AND c2.order_date <= cte.order_date) AS cumulative_categories,
    
    -- Running total for this category
    COUNT(*) OVER (
        PARTITION BY customer_id, product_category 
        ORDER BY order_date
    ) AS running_category_total

FROM cte
ORDER BY customer_id, order_date;