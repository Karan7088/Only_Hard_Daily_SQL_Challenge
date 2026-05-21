 WITH RECURSIVE cte AS (
    SELECT
        city,
        MIN(request_time) AS st,
        DATE_ADD(MIN(request_time), INTERVAL 15 MINUTE) AS ed,
        MAX(request_time) AS mx
    FROM ride_requests
    GROUP BY city

    UNION

    SELECT
        city,
        ed,
        ed + INTERVAL 15 MINUTE,
        mx
    FROM cte
    WHERE ed <= mx
),

cte2 AS (
    SELECT
        city,
        st,
        ed
    FROM cte
    ORDER BY city, st
),

cte3 AS (
    SELECT
        cte2.*,
        d.status,
        d.event_time,
        d.driver_id,
        TIMESTAMPDIFF(MINUTE, st, event_time) AS ord,

        CASE
            WHEN MIN(d.event_time) OVER (PARTITION BY driver_id) <= st
                 AND MAX(d.event_time) OVER (PARTITION BY driver_id) <= st
            THEN 15

            WHEN MIN(d.event_time) OVER (PARTITION BY driver_id) > st
                 AND MAX(d.event_time) OVER (PARTITION BY driver_id) < ed
                 AND MIN(d.event_time) OVER (PARTITION BY driver_id)
                     != MAX(d.event_time) OVER (PARTITION BY driver_id)
            THEN TIMESTAMPDIFF(
                MINUTE,
                MIN(d.event_time) OVER (PARTITION BY driver_id),
                MAX(d.event_time) OVER (PARTITION BY driver_id)
            )

            WHEN MIN(d.event_time) OVER (PARTITION BY driver_id) <= st
                 AND MAX(d.event_time) OVER (PARTITION BY driver_id) <= ed
            THEN TIMESTAMPDIFF(
                MINUTE,
                st,
                MAX(d.event_time) OVER (PARTITION BY driver_id)
            )

            WHEN MIN(d.event_time) OVER (PARTITION BY driver_id) > st
                 AND MAX(d.event_time) OVER (PARTITION BY driver_id) > ed
            THEN TIMESTAMPDIFF(
                MINUTE,
                MIN(d.event_time) OVER (PARTITION BY driver_id),
                ed
            )

            WHEN MIN(d.event_time) OVER (PARTITION BY driver_id)
                 = MAX(d.event_time) OVER (PARTITION BY driver_id)
                 AND MAX(d.event_time) OVER (PARTITION BY driver_id) <= ed
                 AND MIN(d.event_time) OVER (PARTITION BY driver_id) >= st
            THEN TIMESTAMPDIFF(MINUTE, event_time, ed)

            ELSE 15
        END AS df_cal_min,

        MAX(CASE WHEN status = 'offline' THEN d.event_time END)
            OVER (PARTITION BY driver_id) AS mx
    FROM cte2
    LEFT JOIN driver_events d
        ON cte2.city = d.city
),

cte4 AS (
    SELECT
        cte2.*,
        request_time
    FROM cte2
    INNER JOIN ride_requests r
        ON r.city = cte2.city
       AND r.request_time BETWEEN cte2.st AND cte2.ed
),

fnl AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY city, driver_id
            ORDER BY ord DESC
        ) AS rn
    FROM cte3
    WHERE NOT (mx IS NOT NULL AND mx < st)
      AND status != 'offline'
),

fnl2 AS (
    SELECT
        city,
        st,
        ed,
        COUNT(*) AS ride_requests
    FROM cte4
    GROUP BY city, st, ed
),

final AS (
    SELECT
        fnl.*,
        fnl2.ride_requests
    FROM fnl
    INNER JOIN fnl2
        ON fnl.city = fnl2.city
       AND fnl.st = fnl2.st
)

SELECT
    city,
    st,
    ed,
    SUM(df_cal_min) AS active_driver_minutes,
    ride_requests,
    ROUND(SUM(df_cal_min) / 15, 2) AS effective_drivers,
    ROUND(
        ride_requests / ROUND(SUM(df_cal_min) / 15, 2),
        2
    ) AS ratio,
    CASE
        WHEN ROUND(
            ride_requests / ROUND(SUM(df_cal_min) / 15, 2),
            2
        ) >= 3
        THEN 'SURGE_ON'
        ELSE 'NORMAL'
    END AS surge_status
FROM final
GROUP BY city, st, ed, ride_requests;
