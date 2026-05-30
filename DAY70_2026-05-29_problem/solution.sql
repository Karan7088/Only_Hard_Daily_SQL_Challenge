 WITH base AS (
    SELECT
        p.*,

        MIN(attempt_time) OVER (
            PARTITION BY order_id
        ) AS first_attempt_time,

        MIN(
            CASE
                WHEN payment_status = 'SUCCESS'
                THEN attempt_time
            END
        ) OVER (
            PARTITION BY order_id
        ) AS successful_attempt_time,

        MIN(
            CASE
                WHEN payment_status = 'SUCCESS'
                THEN gateway_id
            END
        ) OVER (
            PARTITION BY order_id
        ) AS successful_gateway,

        ROW_NUMBER() OVER (
            PARTITION BY order_id
            ORDER BY attempt_time
        ) AS rn,

        MAX(
            CASE
                WHEN o.event_type = 'ORDER_CREATED' THEN 1
                WHEN o.event_type = 'ORDER_CANCELLED' THEN 2
                ELSE 3
            END
        ) OVER (
            PARTITION BY o.order_id
        ) AS st,

        ROW_NUMBER() OVER (
            PARTITION BY attempt_id
            ORDER BY attempt_time DESC
        ) AS dedup,

        MAX(
            CASE
                WHEN event_type = 'ORDER_EXPIRED'
                THEN event_time
            END
        ) OVER (
            PARTITION BY order_id
        ) AS expired_time

    FROM payment_attempts p
    LEFT JOIN order_events o
        ON o.order_id = p.order_id
),

cte AS (
    SELECT
        expired_time,
        order_id,
        user_id,

        CASE
            WHEN rn = 1 THEN attempt_time
        END AS first_attempt_time,

        CASE
            WHEN rn = 1 THEN gateway_id
        END AS first_gateway,

        rn,

        CASE
            WHEN rn = 1 THEN payment_status
        END AS first_status,

        successful_attempt_time,
        successful_gateway,

        COUNT(*) OVER (
            PARTITION BY order_id
        ) AS total_attempts,

        COUNT(
            CASE
                WHEN payment_status = 'FAILED'
                THEN 1
            END
        ) OVER (
            PARTITION BY order_id
        ) AS failed_attempts,

        COUNT(
            CASE
                WHEN payment_status = 'SUCCESS'
                THEN 1
            END
        ) OVER (
            PARTITION BY order_id
        ) AS success_attempts,

        CASE st
            WHEN 1 THEN 'ORDER_CREATED'
            WHEN 2 THEN 'ORDER_CANCELLED'
            ELSE 'ORDER_EXPIRED'
        END AS final_order_status

    FROM base
    WHERE dedup = 1
)

SELECT
    order_id,
    user_id,
    first_attempt_time,
    first_gateway,
    successful_attempt_time,
    successful_gateway,
    total_attempts,
    failed_attempts,
    success_attempts,
    final_order_status,

    CASE
        WHEN success_attempts > 1
            THEN 'DUPLICATE_SUCCESS'

        WHEN final_order_status = 'ORDER_CANCELLED'
             AND success_attempts > 0
            THEN 'REVENUE_LEAKAGE'

        WHEN successful_attempt_time > expired_time
            THEN 'SUCCESS_AFTER_ORDER_EXPIRED'

        WHEN first_status = 'FAILED'
             AND success_attempts > 0
             AND first_gateway <> successful_gateway
            THEN 'RECOVERED_AFTER_GATEWAY_SWITCH'

        WHEN first_status = 'FAILED'
             AND success_attempts > 0
            THEN 'RECOVERED_AFTER_FAILURE'

        WHEN first_status = 'SUCCESS'
            THEN 'FIRST_ATTEMPT_SUCCESS'

        ELSE 'FAILED_NEVER_RECOVERED'
    END AS payment_recovery_status

FROM cte
WHERE rn = 1;
