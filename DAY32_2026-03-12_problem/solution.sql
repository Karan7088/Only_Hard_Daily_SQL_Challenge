 WITH cte AS (
    SELECT 
        b.*,
        l.city,
        l.base_price
    FROM bookings b
    LEFT JOIN listings l 
        ON l.listing_id = b.listing_id
)

SELECT 
    a.*,

    /* bookings in last 7 days */
    (
        SELECT COUNT(*)
        FROM cte
        WHERE listing_id = a.listing_id
        AND booking_date BETWEEN 
            DATE_SUB(a.booking_date, INTERVAL 6 DAY)
            AND a.booking_date
    ) AS bookings_last_7_days,

    /* dynamic pricing logic */
    CASE 

        WHEN (
            SELECT COUNT(*)
            FROM cte
            WHERE listing_id = a.listing_id
            AND booking_date BETWEEN 
                DATE_SUB(a.booking_date, INTERVAL 6 DAY)
                AND a.booking_date
        ) <= 1
        THEN 0.9 * base_price

        WHEN (
            SELECT COUNT(*)
            FROM cte
            WHERE listing_id = a.listing_id
            AND booking_date BETWEEN 
                DATE_SUB(a.booking_date, INTERVAL 6 DAY)
                AND a.booking_date
        ) BETWEEN 2 AND 3
        THEN 1.0 * base_price

        WHEN (
            SELECT COUNT(*)
            FROM cte
            WHERE listing_id = a.listing_id
            AND booking_date BETWEEN 
                DATE_SUB(a.booking_date, INTERVAL 6 DAY)
                AND a.booking_date
        ) BETWEEN 4 AND 5
        THEN 1.1 * base_price

        ELSE 1.25 * base_price

    END AS dynamic_price

FROM cte a
WHERE base_price >= 0;
