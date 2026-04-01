WITH cust_txn AS (
    SELECT 
        o.customer_id,
        o.product_id,
        o.order_date,
        p.launch_date,
        MAX(o.order_date) OVER (PARTITION BY o.customer_id) AS last_order_date
    FROM Orders o
    JOIN Products p
        ON o.product_id = p.product_id
       AND p.launch_date <= o.order_date   -- valid purchases only
    WHERE o.product_id IS NOT NULL
      AND p.launch_date IS NOT NULL
)

SELECT 
    c.customer_id
FROM cust_txn c
GROUP BY c.customer_id
HAVING 
    COUNT(DISTINCT c.product_id) = (
        SELECT COUNT(DISTINCT p.product_id)
        FROM Products p
        WHERE p.launch_date <= MAX(c.last_order_date)
    ); 
