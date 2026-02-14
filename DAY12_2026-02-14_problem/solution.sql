WITH joined AS (
    SELECT 
        p.passenger_id,
        p.arrival_time,
        b.bus_id,
        b.arrival_time AS bus_arrival,
        b.capacity,
        ROW_NUMBER() OVER (ORDER BY b.arrival_time) AS bus_rank,
        ROW_NUMBER() OVER (
            PARTITION BY b.arrival_time 
            ORDER BY p.passenger_id
        ) AS seat_rank
    FROM passengers p
    JOIN buses b 
        ON b.arrival_time >= p.arrival_time
       AND b.capacity > 0
),

filtered AS (
    SELECT *
    FROM joined j
    WHERE passenger_id NOT IN (
        SELECT passenger_id
        FROM joined
        WHERE j.passenger_id = passenger_id
          AND bus_rank < j.bus_rank
          AND seat_rank <= capacity
    )
),

latest_bus AS (
    SELECT
        passenger_id,
        arrival_time,
        capacity,
        bus_id,
        ROW_NUMBER() OVER (
            PARTITION BY passenger_id
            ORDER BY bus_arrival DESC
        ) AS pick_rank
    FROM filtered
),

final_boarding AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY bus_id
               ORDER BY arrival_time
           ) AS final_seat
    FROM latest_bus
    WHERE pick_rank = 1
)

SELECT 
    bus_id,
    COUNT(*) AS passengers_count
FROM final_boarding
WHERE final_seat <= capacity
GROUP BY bus_id;