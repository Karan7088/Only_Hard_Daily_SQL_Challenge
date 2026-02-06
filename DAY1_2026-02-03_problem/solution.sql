-- ============================================
-- PROBLEM 1: COHORT RETENTION ANALYSIS
-- ============================================
WITH cte AS (
    SELECT 
        *,
        CAST(CONCAT(DATE_FORMAT(order_date, '%Y-%m'), '-01') AS DATE) AS my,
        MIN(CAST(CONCAT(DATE_FORMAT(order_date, '%Y-%m'), '-01') AS DATE)) 
            OVER(PARTITION BY customer_id) AS cohort_mth,
        ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date) AS rn 
    FROM orders 
),
cte2 AS (
    SELECT my, COUNT(DISTINCT customer_id) AS c 
    FROM cte 
    WHERE rn = 1  
    GROUP BY 1
),
cte3 AS (
    SELECT 
        my,
        c AS cohort_size,
        ROUND((SELECT COUNT(DISTINCT customer_id) FROM cte 
               WHERE cte2.my = cte.cohort_mth AND cte2.my = cte.my 
               AND status = 'completed') * 100.0 / c, 2) AS mth_0,
        ROUND((SELECT COUNT(DISTINCT customer_id) FROM cte 
               WHERE cte2.my = cte.cohort_mth 
               AND DATE_ADD(cte2.my, INTERVAL 1 MONTH) = cte.my 
               AND status = 'completed') * 100.0 / c, 2) AS mth_1,
        ROUND((SELECT COUNT(DISTINCT customer_id) FROM cte 
               WHERE cte2.my = cte.cohort_mth 
               AND DATE_ADD(cte2.my, INTERVAL 2 MONTH) = cte.my 
               AND status = 'completed') * 100.0 / c, 2) AS mth_2,
        ROUND((SELECT COUNT(DISTINCT customer_id) FROM cte 
               WHERE cte2.my = cte.cohort_mth 
               AND DATE_ADD(cte2.my, INTERVAL 3 MONTH) = cte.my 
               AND status = 'completed') * 100.0 / c, 2) AS mth_3,
        ROUND((SELECT COUNT(DISTINCT customer_id) FROM cte 
               WHERE cte2.my = cte.cohort_mth 
               AND DATE_ADD(cte2.my, INTERVAL 4 MONTH) = cte.my 
               AND status = 'completed') * 100.0 / c, 2) AS mth_4,
        ROUND((SELECT COUNT(DISTINCT customer_id) FROM cte 
               WHERE cte2.my = cte.cohort_mth 
               AND DATE_ADD(cte2.my, INTERVAL 5 MONTH) = cte.my 
               AND status = 'completed') * 100.0 / c, 2) AS mth_5,
        ROUND((SELECT COUNT(DISTINCT customer_id) FROM cte 
               WHERE cte2.my = cte.cohort_mth 
               AND DATE_ADD(cte2.my, INTERVAL 6 MONTH) = cte.my 
               AND status = 'completed') * 100.0 / c, 2) AS mth_6
    FROM cte2
)
SELECT 
    *,
    mth_1 - mth_0 AS mth_0_1,
    mth_2 - mth_1 AS mth_1_2,
    mth_3 - mth_2 AS mth_2_3,
    mth_4 - mth_3 AS mth_3_4,
    mth_5 - mth_4 AS mth_4_5,
    mth_6 - mth_5 AS mth_5_6 
FROM cte3;