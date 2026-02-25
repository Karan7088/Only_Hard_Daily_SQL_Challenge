WITH cte AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            ORDER BY room_id, start_time, booking_id
        ) AS rn,

        ROW_NUMBER() OVER (
            PARTITION BY room_id 
            ORDER BY room_id, start_time, booking_id
        ) AS rn2,

        ROW_NUMBER() OVER (
            PARTITION BY room_id, start_time
        ) AS rn3,

        TIMESTAMPDIFF(
            MINUTE,
            LAG(start_time) OVER (
                PARTITION BY room_id 
                ORDER BY room_id, start_time, booking_id
            ),
            start_time
        ) AS stdf,

        TIMESTAMPDIFF(
            MINUTE,
            start_time,
            LAG(end_time) OVER (
                PARTITION BY room_id 
                ORDER BY room_id, start_time, booking_id
            )
        ) AS stenddf

    FROM bookings
    WHERE start_time < end_time
    ORDER BY room_id, start_time, booking_id
),

cte2 AS (
    SELECT 
        *,
        CASE 
            WHEN stenddf > 0 OR stenddf IS NULL THEN 1
            ELSE -1
        END AS stts
    FROM cte
),

cte3 AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY room_id 
            ORDER BY room_id, start_time, booking_id
        ) AS rn4
    FROM cte2
    WHERE stts = 1
),

cte4 AS (
    SELECT 
        cte2.*,
        IFNULL(cte3.rn4, -1) AS rn4,

        COUNT(*) OVER (
            PARTITION BY room_id, start_time
        ) AS totalcnt,

        COUNT(*) OVER (
            PARTITION BY room_id
        ) AS rmcnt

    FROM cte2
    LEFT JOIN cte3 
        ON cte2.rn = cte3.rn

    ORDER BY room_id, start_time, booking_id
),

cte5 AS (
    SELECT 
        *,
        CASE 
            WHEN rmcnt != totalcnt AND totalcnt > 1 THEN
                (
                    SELECT MIN(rn2)
                    FROM cte4
                    WHERE a.rn > rn
                      AND end_time <= a.start_time
                      AND room_id = a.room_id
                ) + rn3 - 1
            ELSE rn4
        END AS st
    FROM cte4 a
),

cte6 AS (
    SELECT 
        *,
        CASE 
            WHEN st = -1 AND stenddf = 0 
                THEN LAG(st, 1) OVER ()
            WHEN st = -1 AND stenddf != 0 
                THEN LAG(st, 1) OVER () + 1
            ELSE st
        END AS st2
    FROM cte5
)
, cte7 AS (
    SELECT 
        *,
        CASE 
            WHEN stenddf != 0 
                THEN LAG(st2, 1) OVER () + 1
            ELSE st2
        END AS st3
    FROM cte6
)
,cte8 as(select *, CASE 
            WHEN stenddf != 0 
                THEN LAG(st3, 1) OVER () + 1
            ELSE st3
        END AS st4 from cte7)

SELECT 
    booking_id,
    room_id,
    DENSE_RANK() OVER (
        PARTITION BY room_id 
        ORDER BY st4
    ) AS seats
FROM cte8;