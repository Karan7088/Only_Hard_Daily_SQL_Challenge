WITH RECURSIVE flow AS (

    -- Anchor
    SELECT
        t.tx_id,
        t.sender_id,
        t.receiver_id,
        t.amount,
        t.status,
        t.tx_date,
        CAST(t.sender_id AS CHAR(200)) AS path,
        0 AS is_cycle
    FROM trans t
    WHERE t.status = 'success'
      AND t.amount > 0
      AND t.amount IS NOT NULL

    UNION ALL

    -- Recursive expansion
    SELECT
        t.tx_id,
        f.sender_id,
        t.receiver_id,
        t.amount,
        t.status,
        t.tx_date,
        CONCAT(f.path, ',', t.receiver_id) AS path,
        CASE 
            WHEN FIND_IN_SET(t.receiver_id, f.path) > 0 THEN 1
            ELSE f.is_cycle
        END AS is_cycle
    FROM trans t
    JOIN flow f
      ON f.receiver_id = t.sender_id
     AND f.tx_date = t.tx_date
    WHERE t.status = 'success'
      AND t.amount > 0
      AND t.amount IS NOT NULL
      AND t.sender_id <> t.receiver_id
      AND f.is_cycle = 0
),

edges AS (
    SELECT
        sender_id,
        receiver_id,
        tx_date
    FROM flow
    WHERE sender_id <> receiver_id
    GROUP BY sender_id, receiver_id, tx_date
),

agg AS (
    SELECT
        e.sender_id,
        e.tx_date,
        COUNT(*) AS depth,
        COUNT(*) + 1 AS total_nodes,
        (
            SELECT MAX(is_cycle)
            FROM flow f
            WHERE f.sender_id = e.sender_id
              AND f.tx_date = e.tx_date
        ) AS is_cycle
    FROM edges e
    GROUP BY e.sender_id, e.tx_date
)

SELECT
    sender_id,
    tx_date,
    depth,
    total_nodes,
    is_cycle,
    CASE 
        WHEN is_cycle = 0 THEN 'linear'
        ELSE 'cyclic'
    END AS status
FROM agg
ORDER BY tx_date, sender_id;
