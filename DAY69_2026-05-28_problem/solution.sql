WITH base AS (
    SELECT 
        a.*,
        b.txn_id AS next_greater_txn_id,
        b.amount AS next_greater_amount,
        b.txn_time AS next_greater_time,
        
        ROW_NUMBER() OVER (
            PARTITION BY a.txn_id
            ORDER BY b.txn_time, b.txn_id
        ) AS rn

    FROM transactions a
    CROSS JOIN transactions b
    
    WHERE a.customer_id = b.customer_id
        AND b.amount > a.amount
        AND (
                b.txn_time > a.txn_time
                OR (
                    b.txn_time = a.txn_time
                    AND b.txn_id > a.txn_id
                )
            )
)

SELECT
    txn_id,
    customer_id,
    txn_time,
    amount,
    next_greater_txn_id,
    next_greater_amount,
    next_greater_time
FROM base
WHERE rn = 1

UNION

SELECT
    a.*,
    NULL,
    NULL,
    NULL
FROM transactions a

WHERE NOT EXISTS (
    SELECT 1
    FROM base
    WHERE base.txn_id = a.txn_id
)

ORDER BY customer_id, txn_time, txn_id;
