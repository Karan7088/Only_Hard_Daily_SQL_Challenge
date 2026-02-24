WITH events AS (
    SELECT
        room_id,
        event_time,
        event_type,
        CASE 
            WHEN event_type = 'START' THEN 1
            ELSE -1
        END AS delta
    FROM meetings
),

ordered_events AS (
    SELECT
        room_id,
        event_time,
        delta,
        SUM(delta) OVER (
            PARTITION BY room_id
            ORDER BY event_time,
                     CASE WHEN delta = -1 THEN 0 ELSE 1 END
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS running_count
    FROM events
),

valid_rooms AS (
    SELECT
        room_id
    FROM ordered_events
    GROUP BY room_id
    HAVING 
        MIN(running_count) >= 0  
        AND SUM(delta) = 0        
)

SELECT
    o.room_id,
    MAX(o.running_count) AS max_concurrent
FROM ordered_events o
JOIN valid_rooms v
    ON o.room_id = v.room_id
GROUP BY o.room_id
ORDER BY o.room_id;