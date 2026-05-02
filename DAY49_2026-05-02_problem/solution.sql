WITH RECURSIVE route_builder AS (
    SELECT 
        SOURCE,
        DESTINATION,
        PRICE,
        DEPARTURE_TIME,
        ARRIVAL_TIME,
        CONCAT(CAST(SOURCE AS CHAR(1000)), ',', CAST(DESTINATION AS CHAR(1000))) AS LST,
        PRICE AS COST,
        1 AS LVL
    FROM flights
    WHERE departure_time + INTERVAL 30 MINUTE <= arrival_time

    UNION

    SELECT 
        RB.SOURCE,
        F.DESTINATION,
        F.PRICE,
        F.DEPARTURE_TIME,
        F.ARRIVAL_TIME,
        CONCAT(LST, ',', F.DESTINATION) AS LST,
        COST + F.PRICE,
        LVL + 1
    FROM route_builder RB
    INNER JOIN flights F 
        ON F.SOURCE = RB.DESTINATION
       AND FIND_IN_SET(F.DESTINATION, LST) = 0
       AND F.DEPARTURE_TIME >= (RB.ARRIVAL_TIME + INTERVAL 30 MINUTE)
       AND F.DEPARTURE_TIME + INTERVAL 30 MINUTE <= F.ARRIVAL_TIME
),

ranked_paths AS (
    SELECT 
        SOURCE,
        DESTINATION,
        COST AS TOTAL_COST,
        ARRIVAL_TIME AS DESTINATION_TIME,
        LST,
        ROW_NUMBER() OVER (
            PARTITION BY SOURCE, DESTINATION 
            ORDER BY COST, LVL, DEPARTURE_TIME
        ) AS RN
    FROM route_builder
)

SELECT 
    SOURCE,
    DESTINATION,
    TOTAL_COST,
    DESTINATION_TIME,
    REPLACE(LST, ',', '->') AS PATH
FROM ranked_paths
WHERE RN = 1;
