WITH RECURSIVE cte AS (
    
    SELECT 
        order_id,
        customer_id,
        
        TRIM(SUBSTRING_INDEX(product_ids, ',', 1)) AS product,
        SUBSTRING(product_ids, LENGTH(SUBSTRING_INDEX(product_ids, ',', 1)) + 2) AS product_remain,
        
        TRIM(SUBSTRING_INDEX(quantities, ',', 1)) AS quantity,
        SUBSTRING(quantities, LENGTH(SUBSTRING_INDEX(quantities, ',', 1)) + 2) AS qty_rmng,
        
        TRIM(SUBSTRING_INDEX(prices, ',', 1)) AS price,
        SUBSTRING(prices, LENGTH(SUBSTRING_INDEX(prices, ',', 1)) + 2) AS price_rmng
    
    FROM orders_raw
    WHERE 
        LENGTH(product_ids) > 0 
        AND product_ids IS NOT NULL 
        AND quantities IS NOT NULL 
        AND LENGTH(quantities) > 0 
        AND prices IS NOT NULL 
        AND LENGTH(prices) > 0

    UNION
    
    SELECT 
        order_id,
        customer_id,
        
        CAST(TRIM(SUBSTRING_INDEX(product_remain, ',', 1)) AS CHAR(100)) AS product,
        SUBSTRING(product_remain, LENGTH(SUBSTRING_INDEX(product_remain, ',', 1)) + 2) AS product_remain,
        
        TRIM(SUBSTRING_INDEX(qty_rmng, ',', 1)) AS quantity,
        SUBSTRING(qty_rmng, LENGTH(SUBSTRING_INDEX(qty_rmng, ',', 1)) + 2) AS qty_rmng,
        
        TRIM(SUBSTRING_INDEX(price_rmng, ',', 1)) AS price,
        SUBSTRING(price_rmng, LENGTH(SUBSTRING_INDEX(price_rmng, ',', 1)) + 2) AS price_rmng
    
    FROM cte
    WHERE 
        SUBSTRING_INDEX(product_remain, ',', 1) != ''
        AND SUBSTRING_INDEX(qty_rmng, ',', 1) != ''
        AND SUBSTRING_INDEX(price_rmng, ',', 1) != ''
        
        OR (
            SUBSTRING_INDEX(price_rmng, ',', 1) = ''
            AND SUBSTRING(
                price_rmng,
                LENGTH(SUBSTRING_INDEX(price_rmng, ',', 1)) + 2
            ) != ''
        )
)

SELECT 
    order_id,
    customer_id,
    product,
    CAST(quantity AS DECIMAL) AS quantity,
    CAST(price AS DECIMAL) AS price

FROM cte

WHERE 
    product != ''
    AND price != ''
    AND quantity REGEXP '^[0-9]'
    AND price REGEXP '^[0-9][^a-zA-Z]'

ORDER BY 1;

