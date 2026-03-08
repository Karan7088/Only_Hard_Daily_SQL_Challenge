 WITH RECURSIVE cte AS (
    SELECT MIN(request_time) AS mn
    FROM ride_requests

    UNION ALL

    SELECT mn + INTERVAL 5 MINUTE
    FROM cte
    WHERE mn + INTERVAL 5 MINUTE <= (
        SELECT MAX(request_time) 
        FROM ride_requests
    )
),

tme AS (
    SELECT
        mn AS st,
        IFNULL(
            LEAD(mn) OVER (ORDER BY mn),
            mn + INTERVAL 1 MINUTE
        ) AS ed
    FROM cte
),

cte2 AS (
    SELECT
        r.*,
        tme.st AS req_st,
        d.driver_id,
        d.area_id AS darea,
        d.online_time,
        tme.st AS drv_st
    FROM ride_requests r
    INNER JOIN tme
        ON r.request_time >= tme.st
       AND r.request_time <  tme.ed
    INNER JOIN drivers_online d
        ON d.online_time >= tme.st
       AND d.online_time <  tme.ed
       AND r.area_id = d.area_id
    GROUP BY 1,2,3,4,5,6,7,8
),

cte4 AS (
    SELECT
        a.area_id,
        a.req_st,

        (
            SELECT COUNT(DISTINCT request_id)
            FROM cte2
            WHERE a.area_id = area_id
              AND a.req_st = req_st
        ) AS total_req,

        (
            SELECT COUNT(DISTINCT driver_id)
            FROM cte2
            WHERE a.area_id = area_id
              AND a.req_st = req_st
        ) AS total_driver

    FROM cte2 a

    UNION

    SELECT
        r.area_id,
        tme.st,
        COUNT(DISTINCT r.request_id),
        0
    FROM ride_requests r
    INNER JOIN tme
        ON r.request_time >= tme.st
       AND r.request_time <  tme.ed
    WHERE r.area_id NOT IN (
        SELECT DISTINCT area_id FROM cte2
    )
    GROUP BY 1,2,4
)

SELECT
    *,
    
    CASE
        WHEN total_driver != 0
        THEN total_req / total_driver
        ELSE NULL
    END AS ratio,

    CASE
        WHEN total_driver != 0 AND total_req / total_driver <= 1 THEN 1.0
        WHEN total_driver != 0 AND total_req / total_driver > 1
                               AND total_req / total_driver <= 2 THEN 1.5
        WHEN total_driver != 0 AND total_req / total_driver > 2
                               AND total_req / total_driver <= 3 THEN 2.0
        ELSE 3.0
    END AS surge

FROM cte4
ORDER BY area_id, req_st;
