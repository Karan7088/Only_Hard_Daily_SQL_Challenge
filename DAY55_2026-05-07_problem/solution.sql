 WITH event_deduplication AS (

    SELECT *,
    
           ROW_NUMBER() OVER(
               PARTITION BY order_id, event_type
               ORDER BY event_time
           ) AS dedup,

           CASE
               WHEN event_type = 'placed' THEN 1
               WHEN event_type = 'picked_up' THEN 2
               WHEN event_type = 'out_for_delivery' THEN 3
               ELSE 4
           END AS seq

    FROM delivery_events
),

sla_validation AS (

    SELECT *,

           IFNULL(
               seq - LAG(seq) OVER(
                   PARTITION BY order_id
                   ORDER BY event_time, seq
               ),
               1
           ) AS miss_seq,

           COUNT(*) OVER(
               PARTITION BY order_id
           ) AS cnt,

           CASE
               WHEN seq = 2
                    AND TIMESTAMPDIFF(
                        MINUTE,
                        LAG(event_time) OVER(PARTITION BY order_id),
                        event_time
                    ) > 30
               THEN 1

               WHEN seq = 3
                    AND TIMESTAMPDIFF(
                        MINUTE,
                        LAG(event_time) OVER(PARTITION BY order_id),
                        event_time
                    ) > 60
               THEN 2

               WHEN seq = 4
                    AND TIMESTAMPDIFF(
                        MINUTE,
                        LAG(event_time) OVER(PARTITION BY order_id),
                        event_time
                    ) > 45
               THEN 3

               WHEN seq = 1 THEN 0

               ELSE -1
           END AS sla

    FROM event_deduplication

    WHERE dedup = 1

    ORDER BY 1, seq
),

violation_detection AS (

    SELECT *,

           ROW_NUMBER() OVER(
               PARTITION BY order_id
           ) AS rn2,

           CASE

               WHEN cnt < 4 THEN 0

               WHEN MAX(miss_seq) OVER(PARTITION BY order_id) != 1
                    AND MIN(miss_seq) OVER(PARTITION BY order_id) != 1
                    AND cnt = 4
               THEN 1

               WHEN sla = 1 THEN 2

               WHEN sla = 2 THEN 3

               WHEN sla = 3 THEN 4

           END AS violation_reason

    FROM sla_validation
)

SELECT
    order_id,

    CASE
        WHEN MIN(violation_reason) = 0
        THEN 'MISSING_EVENT'

        WHEN MIN(violation_reason) = 1
        THEN 'INVALID_EVENT_SEQUENCE'

        WHEN MIN(violation_reason) = 2
        THEN 'PICKUP_DELAY'

        WHEN MIN(violation_reason) = 3
        THEN 'OUT_FOR_DELIVERY_DELAY'

        WHEN MIN(violation_reason) = 4
        THEN 'DELIVERY_DELAY'
    END AS violation_reason

FROM violation_detection

WHERE violation_reason IS NOT NULL

GROUP BY 1;
