WITH base AS (
    SELECT *,
           CASE
               WHEN LAG(end_time) OVER (
                        PARTITION BY employee_id
                        ORDER BY start_time
                    ) <= start_time
               THEN 1
               ELSE 0
           END AS st
    FROM employee_meetings
),

cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY employee_id
               ORDER BY start_time
           ) AS rn
    FROM base
    WHERE st = 1
),

cte2 AS (
    SELECT base.*,
           IFNULL(
               MAX(cte.rn) OVER (
                   PARTITION BY employee_id
                   ORDER BY start_time
                   ROWS BETWEEN UNBOUNDED PRECEDING
                   AND CURRENT ROW
               ),
               0
           ) AS rn
    FROM base
    LEFT JOIN cte
           ON base.meeting_id = cte.meeting_id
),

cte3 AS (
    SELECT end_time,
           meeting_id,
           employee_id,
           rn,

           MIN(start_time) OVER (
               PARTITION BY employee_id, rn
           ) AS chain_start_time,

           MAX(end_time) OVER (
               PARTITION BY employee_id, rn
           ) AS chain_end_time,

           COUNT(*) OVER (
               PARTITION BY employee_id, rn
           ) AS total_meetings,

           TIMESTAMPDIFF(
               MINUTE,
               MIN(start_time) OVER (
                   PARTITION BY employee_id, rn
               ),
               MAX(end_time) OVER (
                   PARTITION BY employee_id, rn
               )
           ) AS continuous_busy_minutes,

           ROW_NUMBER() OVER (
               PARTITION BY employee_id, rn
           ) AS rn2

    FROM cte2
)

-- SELECT * FROM CTE3 WHERE total_meetings > 1;

,cte4 AS (
    SELECT *,
           MAX(
               CASE
                   WHEN total_meetings > 1
                   THEN end_time
               END
           ) OVER (
               PARTITION BY employee_id
           ) AS mx
    FROM cte3
),

cte5 AS (
    SELECT *,
           (
               SELECT meeting_id
               FROM cte3
               WHERE mx = chain_end_time
                 AND employee_id = a.employee_id
                 AND total_meetings > 1
               ORDER BY meeting_id
               LIMIT 1
           ) AS m_id

    FROM cte4 a

    WHERE mx IS NOT NULL
      AND rn2 = 1
)

-- SELECT * FROM CTE5;

,cte6 AS (
    SELECT *,
           CASE
               WHEN chain_end_time < mx
                AND m_id < meeting_id
               THEN mx
               ELSE chain_end_time
           END AS chain_end_time2
    FROM cte5
)

-- SELECT * FROM CTE6;

,cte7 AS (
    SELECT employee_id,
           rn + 1 AS conflict_chain_id,
           chain_start_time,
           chain_end_time2 AS chain_end_time,
           total_meetings,
           continuous_busy_minutes
    FROM cte6
    WHERE total_meetings > 1
),

cte8 AS (
    SELECT *,
           SUM(total_meetings) OVER (
               PARTITION BY employee_id, chain_end_time
           ) AS total_meetings2,

           ROW_NUMBER() OVER (
               PARTITION BY employee_id, chain_end_time
               ORDER BY continuous_busy_minutes DESC
           ) AS r3

    FROM cte7
)

SELECT employee_id,
       conflict_chain_id,
       chain_start_time,
       chain_end_time,

       total_meetings2 AS total_meetings,

       continuous_busy_minutes,

       CASE
           WHEN total_meetings2 >= 5
            AND continuous_busy_minutes >= 180
           THEN 'EXTREME'

           WHEN total_meetings2 >= 4
            AND continuous_busy_minutes >= 120
           THEN 'HIGH'

           WHEN total_meetings2 >= 2
           THEN 'LOW'
       END AS conflict_level

FROM cte8

WHERE r3 = 1; 
