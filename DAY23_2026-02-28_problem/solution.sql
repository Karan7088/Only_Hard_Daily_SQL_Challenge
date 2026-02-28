WITH flagged_users AS (
    SELECT a.user_id,
           a.txn_time
    FROM transactions a
    JOIN transactions b
      ON a.user_id = b.user_id
     AND b.txn_time BETWEEN a.txn_time
                        AND a.txn_time + INTERVAL 60 MINUTE
    GROUP BY a.user_id, a.txn_time
    HAVING 
        SUM(CASE WHEN b.txn_type = 'credit' THEN b.amount ELSE 0 END)
            >= 3 * SUM(CASE WHEN b.txn_type = 'debit' THEN b.amount ELSE 0 END)
        
        AND
        
        SUM(CASE WHEN b.txn_type = 'credit' THEN b.amount ELSE 0 END)
        -
        SUM(CASE WHEN b.txn_type = 'debit' THEN b.amount ELSE 0 END)
            > 10000
        
        AND
        
        COUNT(CASE WHEN b.txn_type = 'reversal' THEN 1 END) = 0
        
        AND
        
        MAX(CASE WHEN b.txn_type = 'credit' THEN b.amount END)
        /
        SUM(CASE WHEN b.txn_type = 'credit' THEN b.amount ELSE 0 END)
            <= 0.9
),

first_window AS (
    SELECT user_id,
           MIN(txn_time) AS window_start
    FROM flagged_users
    GROUP BY user_id
),

window_txns AS (
    SELECT t.*
    FROM transactions t
    JOIN first_window f
      ON t.user_id = f.user_id
     AND t.txn_time BETWEEN f.window_start
                        AND f.window_start + INTERVAL 60 MINUTE
)

SELECT 
    user_id,
    MIN(txn_time) AS window_start,
    MAX(txn_time) AS window_end,
    SUM(CASE WHEN txn_type = 'credit' THEN amount ELSE 0 END) AS total_credit,
    SUM(CASE WHEN txn_type = 'debit'  THEN amount ELSE 0 END) AS total_debit,
    SUM(CASE WHEN txn_type = 'credit' THEN amount ELSE 0 END)
    -
    SUM(CASE WHEN txn_type = 'debit'  THEN amount ELSE 0 END) AS net_amount
FROM window_txns
GROUP BY user_id;