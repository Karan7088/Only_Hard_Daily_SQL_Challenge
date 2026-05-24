WITH base AS (
    SELECT a.status,
           a.txn_id AS failed_txn_id,
           a.user_id,
           a.merchant_id,
           a.amount,
           a.amount AS failed_amount,
           a.txn_time AS failed_time,

           b.txn_id AS success_txn_id,
           b.txn_time AS success_time,

           TIMESTAMPDIFF(
               MINUTE,
               a.txn_time,
               b.txn_time
           ) AS minutes_to_recover,

           ROW_NUMBER() OVER (
               PARTITION BY b.txn_id
               ORDER BY a.txn_time DESC
           ) AS dedup,

           ROW_NUMBER() OVER (
               PARTITION BY a.txn_id
               ORDER BY b.txn_time
           ) AS dedup2

    FROM payment_attempts a
    LEFT JOIN payment_attempts b
           ON a.user_id = b.user_id
          AND a.amount = b.amount
          AND a.merchant_id = b.merchant_id
          AND a.txn_time < b.txn_time
          AND a.status = 'failed'
          AND b.status = 'success'

    ORDER BY 1
)

-- SELECT * FROM base;

SELECT failed_txn_id,
       user_id,
       merchant_id,
       failed_amount,
       failed_time,

       CASE
           WHEN dedup > 1
             OR minutes_to_recover > 30
           THEN NULL
           ELSE success_txn_id
       END AS success_txn_id,

       CASE
           WHEN dedup > 1
             OR minutes_to_recover > 30
           THEN NULL
           ELSE success_time
       END AS success_time,

       CASE
           WHEN dedup > 1
             OR minutes_to_recover > 30
           THEN NULL
           ELSE minutes_to_recover
       END AS minutes_to_recover,

       CASE
           WHEN minutes_to_recover > 30
             OR dedup > 1
             OR success_txn_id IS NULL
           THEN 'NOT_RECOVERED'
           ELSE 'RECOVERED'
       END AS recovery_status

FROM base

WHERE status = 'failed'
  AND dedup2 = 1

ORDER BY 1;
 
