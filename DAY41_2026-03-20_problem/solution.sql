 WITH cte AS (
    SELECT
        *,
        SUM(revenue) OVER (PARTITION BY product_id, category) AS prd_total,
        MAX(sale_date) OVER (PARTITION BY category, product_id) AS latest_dt,
        SUM(revenue) OVER (PARTITION BY category) AS cat_total,
        ROW_NUMBER() OVER (PARTITION BY category) AS rn
    FROM sales
),

cte2 AS (
    SELECT
        *,
        (
            SELECT SUM(cat_total) / COUNT(DISTINCT category)
            FROM cte
            WHERE rn = 1
        ) AS cat_avg,
        ROW_NUMBER() OVER (PARTITION BY category, product_id) AS rn2
    FROM cte
),

cte3 AS (
    SELECT
        category,
        product_id,
        prd_total,
        latest_dt,
        DENSE_RANK() OVER (
            PARTITION BY category
            ORDER BY prd_total DESC
        ) AS rnk
    FROM cte2
    WHERE cat_total > cat_avg
      AND rn2 = 1
)

SELECT *
FROM cte3
WHERE rnk <= 3;
