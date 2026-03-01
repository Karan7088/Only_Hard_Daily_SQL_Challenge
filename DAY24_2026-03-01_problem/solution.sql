WITH RECURSIVE cte AS (
    
    SELECT 
        *,
        txn_date AS stt,
        CAST(sender_id AS CHAR(200)) AS lst,
        1 AS lvl
    FROM transactions a
    WHERE sender_id != receiver_id

    UNION 

    SELECT 
        t.txn_id,
        cte.sender_id,
        t.receiver_id,
        t.amount + cte.amount AS amount,
        t.txn_date,
        t.txn_date AS ed,
        CONCAT(lst, ',', t.sender_id) AS lst,
        lvl + 1 AS lvl
    FROM cte
    INNER JOIN transactions t
        ON t.sender_id = cte.receiver_id
       AND t.sender_id != t.receiver_id
       AND t.txn_date >= cte.txn_date
       AND DATEDIFF(t.txn_date, cte.txn_date) <= 7
),

cte2 AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY txn_id ORDER BY lvl DESC) rn
    FROM cte
    WHERE lvl >= 3
      AND amount >= 50000
    ORDER BY 2, 5
),

final AS (
    SELECT *
    FROM cte2
    WHERE rn = 1
      AND sender_id = receiver_id
),

status AS (
    SELECT 
        CAST(sender_id AS CHAR(200)) AS send,
        MIN(
            CASE 
                WHEN (
                    SELECT COUNT(*)
                    FROM transactions
                    WHERE a.sender_id = sender_id
                      AND txn_date BETWEEN a.txn_date 
                                      AND a.txn_date + INTERVAL 1 HOUR
                    GROUP BY sender_id
                ) > 3 
                THEN 'high risk' 
                ELSE 'normal' 
            END
        ) AS st
    FROM transactions a
    GROUP BY 1
),

cte3 AS (
    SELECT 
        f.*,
        s.send,
        s.st,
        CASE 
            WHEN FIND_IN_SET(send, lst) > 0 
                 AND s.st = 'high risk'
            THEN 1 
            ELSE 0 
        END AS st2
    FROM final f
    CROSS JOIN status s
)

SELECT 
    lvl AS ring_size,
    amount AS total_amount,
    lst AS user_involved,
    CASE 
        WHEN MAX(st2) = 1 THEN 'high risk'
        ELSE 'normal'
    END AS risk_level
FROM cte3
GROUP BY 1, 2, 3;