 WITH seat AS (
    SELECT 
        seat_class AS class,
        CAST(COUNT(*) AS SIGNED) AS cnt
    FROM seats
    GROUP BY 1
),

joins AS (
    SELECT 
        p.*,
        s.cnt,

        CASE 
            WHEN loyalty_status = 'platinum' THEN 1
            WHEN loyalty_status = 'gold' THEN 2
            WHEN loyalty_status = 'silver' THEN 3
            ELSE 4
        END AS hier,

        CASE 
            WHEN ticket_class = 'business' THEN 1
            WHEN ticket_class = 'premium'  THEN 2
            ELSE 3
        END AS tkt

    FROM passengers p
    LEFT JOIN seat s
        ON s.class = p.ticket_class
    ORDER BY 2,1
),

cte3 AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY ticket_class 
            ORDER BY hier, checkin_time
        ) AS rn
    FROM joins
    ORDER BY 2,7
),

cte4 AS (
    SELECT 
        *,
        CAST(MAX(rn) OVER (PARTITION BY ticket_class) AS SIGNED) AS mx
    FROM cte3
),

cte5 AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY ticket_class 
            ORDER BY hier, checkin_time
        ) AS rn2,

        CASE 
            WHEN (
                SELECT MAX(cnt - mx)
                FROM cte4
                WHERE a.tkt > tkt
                GROUP BY tkt
                HAVING MAX(cnt - mx) > 0
                ORDER BY a.tkt DESC
                LIMIT 1
            )
            THEN (
                SELECT tkt
                FROM cte4
                WHERE a.tkt > tkt
                GROUP BY tkt
                HAVING MAX(cnt - mx) > 0
                ORDER BY a.tkt DESC
                LIMIT 1
            )
            ELSE 'hello'
        END AS upgrade

    FROM cte4 a
    WHERE rn > cnt
),

joins2 AS (
    SELECT *
    FROM cte5 a
    WHERE (
        SELECT MAX(cnt - mx)
        FROM cte4
        WHERE a.upgrade = tkt
    ) >= rn2
),

final AS (

    SELECT 
        passenger_id,
        ticket_class,
        tkt,
        hier
    FROM cte3
    WHERE rn <= cnt

    UNION

    SELECT 
        passenger_id,
        (
            SELECT ticket_class
            FROM cte3
            WHERE tkt = a.upgrade
        ) AS ticket_class,
        upgrade,
        hier
    FROM joins2 a
    ORDER BY tkt DESC, hier
)

SELECT 
    passenger_id,
    ROW_NUMBER() OVER() AS seat_id,
    ticket_class AS seat_class
FROM final;
