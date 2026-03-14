 WITH events AS (
    SELECT flight_id, arrival_time AS event_time
    FROM flights
    
    UNION
    
    SELECT flight_id, departure_time AS event_time
    FROM flights
),

event_flags AS (
    SELECT 
        flight_id,
        event_time,
        CASE 
            WHEN ROW_NUMBER() OVER (PARTITION BY flight_id ORDER BY event_time) = 1 
            THEN 1 
            ELSE -1 
        END AS change_flag
    FROM events
),

adjusted_events AS (
    SELECT 
        event_time,
        CASE 
            WHEN TIMESTAMPDIFF(SECOND, event_time, LAG(event_time) OVER ()) = 0
                 AND change_flag + LAG(change_flag) OVER () = 0
            THEN 0
            ELSE change_flag
        END AS change_flag
    FROM event_flags
),

running_gates AS (
    SELECT 
        event_time,
        SUM(change_flag) OVER (
            ORDER BY event_time
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS active_gates
    FROM adjusted_events
)

SELECT 
    MAX(active_gates) AS required_gates
FROM running_gates;
