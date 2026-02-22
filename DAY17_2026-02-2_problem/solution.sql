WITH cte AS (
    SELECT 
        CAST(DATE_FORMAT(sale_date, '%Y-%m-01') AS DATE) AS ym,
        SUM(amount) AS total
    FROM sales
    GROUP BY 1
),

cte2 AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY ym) AS rn,
        ym,
        total - LAG(total) OVER (ORDER BY ym) AS df
    FROM cte
),

cte3 AS (
    SELECT *
    FROM cte2
    WHERE df <= 0
),

cte4 AS (
    SELECT 
        cte2.*,
        IFNULL(
            IFNULL(
                cte3.rn,
                MIN(cte3.rn) OVER (
                    ORDER BY cte2.rn
                    ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
                ) - 1
            ),
            9999
        ) AS rn2
    FROM cte2
    LEFT JOIN cte3 
        ON cte2.rn = cte3.rn
),

cte5 AS (
    SELECT  
        DENSE_RANK() OVER (ORDER BY rn2) AS streak_id,
        MIN(ym) OVER (PARTITION BY rn2) AS st,
        MAX(ym) OVER (PARTITION BY rn2) AS ed,
        COUNT(*) OVER (PARTITION BY rn2) AS streak_length
    FROM cte4
    WHERE df > 0
)

SELECT *
FROM cte5
GROUP BY 1, 2, 3, 4
ORDER BY 1;