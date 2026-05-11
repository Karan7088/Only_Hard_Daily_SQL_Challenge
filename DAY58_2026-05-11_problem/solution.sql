 WITH snapshot_sequence AS (

    SELECT *,
           LEAD(snapshot_time) OVER(
               PARTITION BY product_id
               ORDER BY snapshot_time
           ) AS ld,

           ROW_NUMBER() OVER(
               PARTITION BY product_id
               ORDER BY snapshot_time
           ) AS rn

    FROM inventory_snapshots
),

stockout_rows AS (

    SELECT *,
           rn - LAG(rn, 1, rn - 1) OVER(
               PARTITION BY product_id
               ORDER BY rn
           ) AS df

    FROM snapshot_sequence

    WHERE stock_quantity = 0
),

stockout_breaks AS (

    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY product_id
           ) AS rn2

    FROM stockout_rows

    WHERE df > 1
),

stockout_grouping AS (

    SELECT
        stockout_rows.*,

        IFNULL(
            IFNULL(
                stockout_breaks.rn2,
                MAX(rn2) OVER(
                    PARTITION BY product_id
                    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                )
            ),
            0
        ) AS rn2,

        COUNT(*) OVER(
            PARTITION BY product_id, df
            ORDER BY snapshot_time
        ) AS CNT,

        ROW_NUMBER() OVER(
            PARTITION BY product_id, df
        ) AS RN3

    FROM stockout_rows

    LEFT JOIN stockout_breaks
        ON stockout_rows.rn = stockout_breaks.rn
       AND stockout_rows.product_id = stockout_breaks.product_id
),

stockout_summary AS (

    SELECT
        product_id,

        MIN(snapshot_time) AS stockout_start,

        MAX(
            CASE
                WHEN cnt = rn3 AND ld IS NOT NULL THEN ld
                ELSE 'NULL'
            END
        ) AS recovery_time,

        TIMESTAMPDIFF(
            MINUTE,
            MIN(snapshot_time),
            MAX(ld)
        ) AS stockout_duration_minutes

    FROM stockout_grouping

    GROUP BY 1, rn2
),

final_incidents AS (

    SELECT
        product_id,

        stockout_start,

        CASE
            WHEN recovery_time = 'null' THEN NULL
            ELSE stockout_duration_minutes
        END AS stockout_duration_minutes,

        ROW_NUMBER() OVER(
            PARTITION BY product_id
            ORDER BY stockout_start
        ) AS incident_number

    FROM stockout_summary
)

SELECT *,
       CASE
           WHEN stockout_duration_minutes IS NULL THEN 'NOT_RECOVERED'
           ELSE 'RECOVERED'
       END AS recovery_status

FROM final_incidents;
