WITH base AS (
    SELECT *,
           TIMESTAMPDIFF(MINUTE, start_time,
               LAG(end_time) OVER (PARTITION BY machine_id ORDER BY start_time)
           ) AS df
    FROM machine_logs
    WHERE start_time < end_time
),

time_points AS (
    SELECT machine_id, user_id, start_time
    FROM base
    WHERE df > 0 OR df IS NULL

    UNION

    SELECT machine_id, user_id, end_time
    FROM base
    WHERE df > 0 OR df IS NULL
),

windows AS (
    SELECT machine_id,
           user_id,
           start_time,
           LEAD(start_time) OVER (PARTITION BY machine_id ORDER BY start_time) AS end_time
    FROM time_points
),

overlaps AS (
    SELECT
        a.user_id,
        a.machine_id,
        a.start_time AS astart,
        a.end_time   AS aend,
        b.start_time AS bstart,
        b.end_time   AS bend,
        COUNT(*) OVER (PARTITION BY b.start_time, b.end_time) AS c
    FROM base a
    INNER JOIN windows b
        ON a.machine_id = b.machine_id
       AND a.start_time <= b.start_time
       AND a.end_time   >= b.end_time
    WHERE b.end_time IS NOT NULL
      AND (df > 0 OR df IS NULL)
      AND b.start_time != b.end_time
    ORDER BY machine_id, bstart
),

overlap_max AS (
    SELECT *,
           MAX(c) OVER (
               PARTITION BY machine_id
               ORDER BY bstart
               ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
           ) AS mx
    FROM overlaps
),

ranked AS (
    SELECT
        machine_id,
        user_id,
        astart,
        bstart,
        bend,
        c,
        ROW_NUMBER() OVER (PARTITION BY machine_id, bstart, bend) AS rn,
        DENSE_RANK() OVER (
            PARTITION BY machine_id
            ORDER BY c DESC, bstart ASC
        ) AS rnk
    FROM overlap_max a
    WHERE mx = (
              SELECT MAX(mx)
              FROM overlap_max
              WHERE machine_id = a.machine_id
          )
      AND bstart != bend
      AND c > 1
),

dedup_users AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY machine_id, user_id, bstart, bend
           ) AS rn2
    FROM ranked
),

final_users AS (
    SELECT *,
           COUNT(*) OVER (PARTITION BY machine_id, bstart, bend) AS cnt
    FROM dedup_users
    WHERE rn2 = 1
),

conflict_windows AS (
    SELECT machine_id, bstart, bend
    FROM overlap_max
    WHERE c > 1
    GROUP BY 1, 2, 3
)

SELECT
    machine_id,

    (
        SELECT MAX(cnt)
        FROM final_users
        WHERE machine_id = a.machine_id
    ) AS max_concurrent_users,

    CASE
        WHEN (
            SELECT COUNT(*)
            FROM ranked b
            WHERE b.machine_id = a.machine_id
              AND rnk = (
                  SELECT MAX(rnk)
                  FROM ranked c
                  WHERE b.machine_id = c.machine_id
              )
        ) > 1
        THEN (
            SELECT SUM(TIMESTAMPDIFF(MINUTE, bstart, bend))
            FROM conflict_windows
            WHERE machine_id = a.machine_id
        )
        ELSE 0
    END AS conflict_min,

    (
        SELECT GROUP_CONCAT(DISTINCT user_id ORDER BY user_id SEPARATOR ',')
        FROM ranked
        WHERE a.machine_id = machine_id
          AND rnk = 1
    ) AS users

FROM ranked a
WHERE c > 1
GROUP BY 1;
