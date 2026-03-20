 WITH base AS (
    SELECT 
        *,
        DATEDIFF(check_out, check_in) AS df,
        ROW_NUMBER() OVER (
            PARTITION BY room_id 
            ORDER BY check_in
        ) AS rn
    FROM hotel_bookings
),

cte AS (
    SELECT 
        *,
        
        CASE 
            WHEN check_in < (
                    SELECT MAX(check_out) 
                    FROM base 
                    WHERE rn < a.rn 
                      AND room_id = a.room_id
                 )
             AND check_out < (
                    SELECT MAX(check_out) 
                    FROM base 
                    WHERE rn < a.rn 
                      AND room_id = a.room_id
                 )
            THEN 0

            WHEN check_in < (
                    SELECT MAX(check_out) 
                    FROM base 
                    WHERE rn < a.rn 
                      AND room_id = a.room_id
                 )
             AND check_out >= (
                    SELECT MAX(check_out) 
                    FROM base 
                    WHERE rn < a.rn 
                      AND room_id = a.room_id
                 )
            THEN DATEDIFF(
                    check_out,
                    (
                        SELECT MAX(check_out) 
                        FROM base 
                        WHERE rn < a.rn 
                          AND a.room_id = room_id
                    )
                 )

            ELSE df 
        END AS st

    FROM base a
)

SELECT 
    room_id,
    SUM(DATEDIFF(check_out, check_in)) AS total_booked_days,
    SUM(st) AS unique_booking_days,
    
    CASE 
        WHEN SUM(DATEDIFF(check_out, check_in)) > SUM(st) 
        THEN 1 
        ELSE 0 
    END AS over_booked

FROM cte
GROUP BY 1;
