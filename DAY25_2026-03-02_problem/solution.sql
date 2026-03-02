WITH price_diff AS (
    SELECT
        product_id,
        price_date,
        price,
        price - LAG(price) OVER (
            PARTITION BY product_id 
            ORDER BY price_date
        ) AS price_change,
        COUNT(*) OVER (
            PARTITION BY product_id
        ) AS total_records
    FROM prod
),

volatility_calc AS (
    SELECT
        product_id,
        ROUND(
            STDDEV_POP(price_change) OVER (
                PARTITION BY product_id
            ), 
        2) AS volatility,
        total_records,
        MAX(ABS(price_change)) OVER (
            PARTITION BY product_id
        ) AS max_jump
    FROM price_diff
    WHERE total_records > 1
      AND price_change IS NOT NULL
)

SELECT
    product_id,
    volatility,
    total_records,
    max_jump
FROM volatility_calc
GROUP BY 
    product_id,
    volatility,
    total_records,
    max_jump
ORDER BY volatility DESC
LIMIT 3;
