 WITH event_base AS (
    SELECT
        *,
        MAX(warehouse_id) OVER (
            PARTITION BY product_id
        ) AS end_warehouse,

        CASE
            WHEN event_type IN ('transfer_out', 'sale')
                THEN 0 - quantity
            ELSE quantity
        END AS signed_quantity,

        CASE event_type
            WHEN 'transfer_out' THEN 1
            WHEN 'transfer_in' THEN -1
            WHEN 'adjustment' THEN 3
            WHEN 'SALE' THEN 4
            WHEN 'receipt' THEN 0
        END AS event_rank,

        COUNT(
            CASE
                WHEN event_type = 'transfer_in'
                THEN 1
            END
        ) OVER (
            PARTITION BY product_id, reference_id
        ) AS duplicate_transfer_in_count,

        COUNT(
            CASE
                WHEN event_type = 'sale'
                THEN 1
            END
        ) OVER (
            PARTITION BY product_id
        ) AS sale_count,

        CASE
            WHEN LEAD(quantity) OVER (
                PARTITION BY product_id, reference_id
            ) != quantity
                THEN 1
            ELSE 0
        END AS quantity_mismatch_flag

    FROM inventory_events
),

event_metrics AS (
    SELECT
        *,

        ROW_NUMBER() OVER (
            PARTITION BY product_id, event_type, reference_id
        ) AS duplicate_event_rank,

        COUNT(*) OVER (
            PARTITION BY product_id, reference_id
        ) AS reference_event_count,

        SUM(signed_quantity) OVER (
            PARTITION BY product_id, reference_id
        ) AS reference_quantity_sum,

        ROW_NUMBER() OVER (
            PARTITION BY product_id
        ) AS product_row_rank,

        MIN(
            CASE
                WHEN event_type = 'adjustment'
                    THEN quantity
                ELSE 0
            END
        ) OVER (
            PARTITION BY product_id
        ) AS adjustment_loss_quantity,

        MAX(quantity_mismatch_flag) OVER (
            PARTITION BY product_id, reference_id
        ) AS has_quantity_mismatch,

        IFNULL(
            SUM(
                CASE
                    WHEN event_type IN ('transfer_in', 'transfer_out')
                        THEN event_rank
                END
            ) OVER (
                PARTITION BY product_id, reference_id
            ),
            -100
        ) AS transfer_balance_status,

        LAST_VALUE(event_rank) OVER (
            PARTITION BY product_id
            ORDER BY event_time
            ROWS BETWEEN UNBOUNDED PRECEDING
                 AND UNBOUNDED FOLLOWING
        ) AS last_event_rank,

        LAG(event_type) OVER (
            PARTITION BY product_id
            ORDER BY event_time
        ) AS previous_event_type,

        COUNT(
            CASE
                WHEN event_type = 'transfer_out'
                THEN 1
            END
        ) OVER (
            PARTITION BY product_id
        ) AS total_transfer_hops,

        MAX(
            CASE
                WHEN event_type = 'receipt'
                    THEN quantity
                ELSE 0
            END
        ) OVER (
            PARTITION BY product_id
        ) AS received_qty,

        SUM(
            CASE
                WHEN event_type = 'sale'
                    THEN quantity
            END
        ) OVER (
            PARTITION BY product_id
        ) AS sold_qty,

        SUM(
            CASE
                WHEN event_type = 'adjustment'
                    THEN quantity
            END
        ) OVER (
            PARTITION BY product_id
        ) AS adjusted_qty

    FROM event_base
    ORDER BY event_id
),

chain_flags AS (
    SELECT
        *,

        SUM(
            CASE
                WHEN duplicate_event_rank = 1
                     AND event_type IN ('transfer_in', 'transfer_out', 'sale', 'adjustment')
                    THEN signed_quantity
            END
        ) OVER (
            PARTITION BY product_id
        ) AS anomaly_quantity,

        ROW_NUMBER() OVER (
            PARTITION BY product_id, warehouse_id
            ORDER BY event_time
        ) AS warehouse_visit_rank,

        CASE
            WHEN last_event_rank = 1
                THEN 'MISSING_TRANSFER_IN'
            WHEN last_event_rank = -1
                 AND previous_event_type = 'transfer_in'
                THEN 'DUPLICATE_TRANSFER'
            ELSE end_warehouse
        END AS chain_end_warehouse,

        MIN(warehouse_id) OVER (
            PARTITION BY product_id
        ) AS chain_start_warehouse,

        MAX(transfer_balance_status) OVER (
            PARTITION BY product_id
        ) AS transfer_status

    FROM event_metrics
),

warehouse_path AS (
    SELECT
        product_id,
        GROUP_CONCAT(
            warehouse_id
            ORDER BY warehouse_id
            SEPARATOR '->'
        ) AS warehouses_involved
    FROM chain_flags
    WHERE warehouse_visit_rank = 1
    GROUP BY product_id
    ORDER BY product_id
),

suspicious_products AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY product_id
            ORDER BY event_id DESC
        ) AS final_event_rank
    FROM chain_flags
    WHERE product_row_rank = 1
      AND (
            has_quantity_mismatch > 0
            OR duplicate_transfer_in_count >= 2
            OR (
                sale_count = 0
                AND last_event_rank = 3
            )
            OR (
                transfer_status != 0
                AND transfer_status != -100
            )
        )
      OR (
            reference_event_count > 1
            AND reference_quantity_sum != 0
        )
)

SELECT
    suspicious_products.product_id,
    event_id,
    warehouse_id,
    ROW_NUMBER() OVER (
        ORDER BY event_id
    ) AS chain_id,
    chain_start_warehouse,
    chain_end_warehouse,
    warehouse_path.warehouses_involved,
    total_transfer_hops,
    received_qty,
    IFNULL(sold_qty, 0) AS sold_qty,
    ABS(IFNULL(adjusted_qty, 0)) AS adjusted_qty,
    ABS(anomaly_quantity) AS missing_qty,

    CASE
        WHEN ABS(anomaly_quantity) > 100
            THEN 'CRITICAL'
        WHEN ABS(anomaly_quantity) > 50
             AND ABS(anomaly_quantity) <= 100
            THEN 'HIGH'
        WHEN ABS(anomaly_quantity) > 20
             AND ABS(anomaly_quantity) <= 50
            THEN 'MEDIUM'
        ELSE 'LOW'
    END AS risk_level

FROM suspicious_products
LEFT JOIN warehouse_path
    ON suspicious_products.product_id = warehouse_path.product_id
WHERE final_event_rank = 1
ORDER BY chain_id;
