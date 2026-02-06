-- ============================================
-- PROBLEM 3: SEQUENTIAL PATTERN DETECTION
-- ============================================

WITH order_stats AS (
    SELECT 
        o.customer_id,
        o.order_id,
        o.order_date,
        o.order_amount,
        o.discount_amount,
        o.device_type,
        oi.product_category,
        oi.unit_price,
        oi.quantity,
        AVG(oi.unit_price) OVER (PARTITION BY o.order_id) AS avg_unit_price_order,
        CASE WHEN o.discount_amount > 0 THEN 1 ELSE 0 END AS has_discount
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.status = 'completed'
),
customer_patterns AS (
    SELECT 
        customer_id,
        
        -- Loyalty Loop: Any category → [different] → Same category
        MAX(CASE 
            WHEN product_category = LAG(product_category, 2) OVER (PARTITION BY customer_id ORDER BY order_date)
            AND product_category != LAG(product_category, 1) OVER (PARTITION BY customer_id ORDER BY order_date)
            THEN 1 
            ELSE 0 
        END) AS loyalty_loop,
        
        -- Category Escalation: 3+ orders with strictly increasing avg price
        MAX(CASE 
            WHEN avg_unit_price_order > LAG(avg_unit_price_order, 1) OVER (PARTITION BY customer_id ORDER BY order_date)
            AND LAG(avg_unit_price_order, 1) OVER (PARTITION BY customer_id ORDER BY order_date) > 
                LAG(avg_unit_price_order, 2) OVER (PARTITION BY customer_id ORDER BY order_date)
            THEN 1 
            ELSE 0 
        END) AS category_escalation,
        
        -- Discount Hunter: >50% orders have discount
        CASE 
            WHEN SUM(has_discount) * 1.0 / COUNT(*) > 0.5 THEN 1 
            ELSE 0 
        END AS discount_hunter,
        
        -- Device Switcher: ≥3 different devices
        CASE 
            WHEN COUNT(DISTINCT device_type) >= 3 THEN 1 
            ELSE 0 
        END AS device_switcher
        
    FROM order_stats
    GROUP BY customer_id
)
SELECT 
    customer_id,
    loyalty_loop,
    category_escalation,
    discount_hunter,
    device_switcher,
    loyalty_loop + category_escalation + discount_hunter + device_switcher AS pattern_count
FROM customer_patterns;