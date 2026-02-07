WITH base AS (
    SELECT 
        c.customer_id,
        c.acquisition_channel,
        c.registration_date,
        o.order_id,
        o.order_date,
        o.order_amount - o.discount_amount AS net_amount,
        o.status
    FROM customers c
    INNER JOIN orders o ON o.customer_id = c.customer_id
),

converted AS (
    SELECT 
        acquisition_channel,
        customer_id,
        MIN(DATEDIFF(order_date, registration_date)) AS days_to_first
    FROM base
    WHERE status = 'completed'
    GROUP BY 1, 2
    HAVING days_to_first <= 30
),

metrics AS (
    SELECT 
        acquisition_channel,
        COUNT(DISTINCT customer_id) AS converted_30d,
        AVG(days_to_first) AS avg_time_to_first_purchase
    FROM converted
    GROUP BY 1
),

revenue AS (
    SELECT 
        acquisition_channel,
        SUM(net_amount) AS total_revenue
    FROM base
    WHERE status = 'completed'
    GROUP BY 1
),

registered AS (
    SELECT 
        acquisition_channel,
        COUNT(DISTINCT customer_id) AS total_registered
    FROM base
    GROUP BY 1
),

sticky_calc AS (
    SELECT 
        acquisition_channel,
        customer_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_order_date,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS rn
    FROM base
    WHERE status = 'completed'
),

sticky AS (
    SELECT 
        acquisition_channel,
        COUNT(DISTINCT customer_id) AS sticky_customers
    FROM sticky_calc
    WHERE rn = 2 
      AND DATEDIFF(order_date, prev_order_date) <= 60
    GROUP BY 1
)

SELECT 
    r.acquisition_channel,
    r.total_registered,
    m.converted_30d,
    ROUND(m.converted_30d / r.total_registered * 100, 2) AS conversion_rate,
    ROUND(m.avg_time_to_first_purchase, 2) AS avg_time_to_first_purchase,
    rev.total_revenue,
    s.sticky_customers,
    ROUND(s.sticky_customers / m.converted_30d * 100, 2) AS stickiness_rate
FROM registered r
LEFT JOIN metrics m ON m.acquisition_channel = r.acquisition_channel
LEFT JOIN revenue rev ON rev.acquisition_channel = r.acquisition_channel
LEFT JOIN sticky s ON s.acquisition_channel = r.acquisition_channel;