
WITH base AS (
    SELECT *,
           ABS(system_stock - physical_stock) AS miss_mtch,
           IFNULL(
               DATEDIFF(
                   audit_time,
                   LAG(audit_time) OVER (
                       PARTITION BY warehouse_id, product_id
                       ORDER BY audit_time
                   )
               ),
               1
           ) AS df
    FROM inventory_audits
),

cte AS (
    SELECT *,
           MIN(miss_mtch) OVER (
               PARTITION BY warehouse_id, product_id
           ) AS mn_ms_mtch,

           MAX(df) OVER (
               PARTITION BY warehouse_id, product_id
           ) AS mx_df
    FROM base
)

SELECT warehouse_id,
       product_id,
       MIN(audit_time) AS mismatch_start_time,
       MAX(audit_time) AS mismatch_start_time,
       COUNT(*) AS consecutive_mismatch_audits,
       SUM(miss_mtch) AS total_stock_gap,
       MAX(miss_mtch) AS max_stock_gap,

       COUNT(
           CASE
               WHEN adjustment_done = 'yes' THEN 1
           END
       ) AS adjustment_attempts,

       MAX('UNRESOLVED') AS final_status

FROM cte
WHERE mn_ms_mtch > 0
  AND mx_df = 1

GROUP BY 1,2
ORDER BY 1; 
