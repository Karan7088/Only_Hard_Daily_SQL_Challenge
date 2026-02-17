WITH RECURSIVE money_chain AS (
    SELECT 
        t.sender_id AS start_user,
        t.sender_id,
        t.receiver_id,
        CAST(t.sender_id AS CHAR(500)) AS path,
        t.amount,
        t.txn_time AS start_time,
        t.txn_time AS last_time,
        1 AS depth
    FROM transactions t
    WHERE t.status = 'SUCCESS'
      AND t.amount > 10000

    UNION ALL

    SELECT
        mc.start_user,
        t.sender_id,
        t.receiver_id,
        CONCAT(mc.path, ',', t.sender_id),
        mc.amount + t.amount,
        mc.start_time,
        t.txn_time,
        mc.depth + 1
    FROM money_chain mc
    JOIN transactions t
        ON mc.receiver_id = t.sender_id
    WHERE t.status = 'SUCCESS'
      AND t.amount > 10000
      AND mc.depth < 6
      AND FIND_IN_SET(t.sender_id, mc.path) = 0
      AND t.txn_time > mc.last_time              -- 🔥 FIX 1
      AND TIMESTAMPDIFF(HOUR, mc.start_time, t.txn_time) <= 48
),

cycles AS (
    SELECT
        start_user,
        CONCAT(path, ',', receiver_id) AS full_path,
        amount AS total_amount,
        start_time,
        last_time,
        depth + 1 AS user_count
    FROM money_chain
    WHERE receiver_id = start_user
      AND depth >= 2
),

canonical_cycles AS (
    SELECT *
    FROM cycles c
    WHERE start_user = (
        SELECT MIN(val)
        FROM (
            SELECT CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(c.full_path, ',', n.n), ',', -1) AS UNSIGNED) AS val
            FROM (
                SELECT 1 n UNION SELECT 2 UNION SELECT 3 
                UNION SELECT 4 UNION SELECT 5 UNION SELECT 6
            ) n
            WHERE n.n <= LENGTH(c.full_path) - LENGTH(REPLACE(c.full_path, ',', '')) + 1
        ) 
    )
),

fraud_cycles AS (
    SELECT 
        cc.full_path,
        cc.total_amount,
        cc.user_count,
        TIMESTAMPDIFF(HOUR, cc.start_time, cc.last_time) AS duration_hours,
        CASE 
            WHEN COUNT(DISTINCT u.user_id) > 0 THEN 'YES'
            ELSE 'NO'
        END AS has_high_risk
    FROM canonical_cycles cc
    LEFT JOIN users u
        ON FIND_IN_SET(u.user_id, cc.full_path)
       AND u.risk_level = 'HIGH'
    GROUP BY cc.full_path, cc.total_amount, cc.user_count, cc.start_time, cc.last_time
)

SELECT
    DENSE_RANK() OVER (ORDER BY total_amount DESC) AS cycle_id,
    REPLACE(full_path, ',', '→') AS path,
    total_amount,
    user_count,
    has_high_risk,
    duration_hours
FROM fraud_cycles
WHERE has_high_risk = 'YES'
  AND duration_hours BETWEEN 0 AND 48
ORDER BY total_amount DESC;