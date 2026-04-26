WITH dedup_trns AS (
    SELECT 
        txn_id,
        product_id 
    FROM transaction_items 
    GROUP BY txn_id, product_id
),

product_comb AS (
    SELECT 
        a.product_id AS product1,
        b.product_id AS product2 
    FROM dedup_trns a 
    INNER JOIN dedup_trns b 
        ON a.txn_id = b.txn_id 
       AND a.product_id < b.product_id
)

SELECT 
    CASE 
        WHEN product1 < product2 THEN product1 
        ELSE product2 
    END AS product1,

    CASE 
        WHEN product1 < product2 THEN product2 
        ELSE product1  
    END AS product2,

    COUNT(*) AS frequency  

FROM product_comb 

GROUP BY 1, 2  

HAVING COUNT(*) > 2;
