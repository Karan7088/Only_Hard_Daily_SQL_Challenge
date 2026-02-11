WITH RECURSIVE tx AS (  
    -- Base successful transactions
    SELECT 
        sender_id AS root_id,
        receiver_id,
        amount
    FROM transactions
    WHERE status = 'success'
      AND sender_id != receiver_id
      AND amount > 0
      AND sender_id   IN (SELECT DISTINCT user_id FROM users)
      AND receiver_id IN (SELECT DISTINCT user_id FROM users)

    UNION

    -- Recursive chain expansion
    SELECT 
        tx.root_id,
        t.receiver_id,
        t.amount
    FROM tx
    INNER JOIN transactions t
        ON tx.receiver_id = t.sender_id
       AND t.sender_id != t.receiver_id
       AND t.amount > 0
       AND t.status = 'success'
       AND t.sender_id   IN (SELECT DISTINCT user_id FROM users)
       AND t.receiver_id IN (SELECT DISTINCT user_id FROM users)
),

-- Device connections
dev AS (
    SELECT 
        a.user_id AS u1,
        b.user_id AS u2
    FROM device_logins a
    INNER JOIN device_logins b
        ON a.device_id = b.device_id
       AND a.user_id < b.user_id
       AND a.user_id IN (SELECT user_id FROM users)
       AND b.user_id IN (SELECT user_id FROM users)
),

-- Merge transaction graph + device graph
grp AS (
    SELECT root_id, receiver_id
    FROM tx
    WHERE root_id < receiver_id

    UNION

    SELECT * FROM dev
),

-- Normalize cluster root
norm AS (
    SELECT root_id, receiver_id
    FROM grp g
    WHERE root_id <= (
        SELECT MIN(receiver_id)
        FROM grp
        WHERE root_id = g.root_id
    )
),

-- Remove duplicate roots
root_fix AS (
    SELECT *
    FROM norm
    WHERE root_id NOT IN (
        SELECT receiver_id
        FROM norm
        WHERE root_id != receiver_id
    )

    UNION

    SELECT *
    FROM norm
    WHERE root_id = receiver_id
    ORDER BY 1,2
),

-- Expand device-linked users
expand AS (
    SELECT 
        r.*,
        IFNULL(d.u2,'') AS extra_user
    FROM root_fix r
    LEFT JOIN dev d
        ON r.receiver_id = d.u1
),

-- Final graph expansion
full_grp AS (
    SELECT * FROM root_fix
    UNION
    SELECT root_id, extra_user
    FROM expand
    WHERE extra_user != ''
    ORDER BY 1,2
),

-- Attach exposure + fraud
calc AS (
    SELECT 
        f.*,
        t.amount,
        t.sender_id,
        CASE 
            WHEN fa.user_id IS NOT NULL THEN 1 
            ELSE 0 
        END AS fraud_flag
    FROM full_grp f
    LEFT JOIN transactions t
        ON t.sender_id = f.receiver_id
    LEFT JOIN fraud_alerts fa
        ON fa.user_id = f.receiver_id
    GROUP BY 1,2,3,4
),

-- Aggregate per cluster
agg AS (
    SELECT 
        root_id,
        GROUP_CONCAT(DISTINCT receiver_id ORDER BY receiver_id) AS users_in_cluster,
        COUNT(DISTINCT receiver_id) AS total_users,
        SUM(amount) AS total_exposure,
        MAX(fraud_flag) AS fraud_flag
    FROM calc
    GROUP BY 1
    ORDER BY 1
)

-- Final Output Adjustment
SELECT 
    root_id AS cluster_id,
    CONCAT(root_id, ',', users_in_cluster) AS users_in_cluster,
    total_users + 1 AS total_users,
    total_exposure 
        + (SELECT SUM(amount) 
           FROM transactions 
           WHERE agg.root_id = sender_id) AS total_exposure,
    CASE 
        WHEN fraud_flag = 0 
             AND root_id IN (SELECT user_id FROM fraud_alerts)
        THEN 1 
        ELSE fraud_flag 
    END AS fraud_flag
FROM agg;
