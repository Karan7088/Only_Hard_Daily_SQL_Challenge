 WITH badge_sessions AS (
    SELECT
        b.log_id AS session_id,
        b.employee_id,
        b.office_city AS city,
        b.event_time AS entry_time,
        COALESCE((
            SELECT MIN(x.event_time)
            FROM badge_logs x
            WHERE x.employee_id = b.employee_id
              AND x.office_city = b.office_city
              AND x.event_type = 'EXIT'
              AND x.event_time > b.event_time
        ), '9999-12-31 23:59:59') AS exit_time
    FROM badge_logs b
    WHERE b.event_type = 'ENTRY'
),

all_events AS (
    SELECT employee_id, office_city AS city, event_time, 'BADGE_ENTRY' AS src
    FROM badge_logs
    WHERE event_type = 'ENTRY'

    UNION ALL

    SELECT employee_id, office_city AS city, event_time, 'BADGE_EXIT' AS src
    FROM badge_logs
    WHERE event_type = 'EXIT'

    UNION ALL

    SELECT employee_id, login_city AS city, event_time, 'VPN' AS src
    FROM vpn_logs

    UNION ALL

    SELECT employee_id, office_city AS city, event_time, 'MEETING' AS src
    FROM meeting_room_logs
),

badge_conflict_seed AS (
    SELECT
        bs.employee_id,
        bs.entry_time AS seed_start_time,
        MIN(a.event_time) AS first_conflict_time,
        'LOCATION' AS seed_type
    FROM badge_sessions bs
    JOIN all_events a
      ON a.employee_id = bs.employee_id
     AND a.event_time BETWEEN bs.entry_time AND bs.exit_time
     AND a.city <> bs.city
    GROUP BY
        bs.employee_id,
        bs.session_id,
        bs.entry_time
),

travel_conflict_seed AS (
    SELECT
        e.employee_id,
        e.event_time AS seed_start_time,
        MIN(a.event_time) AS first_conflict_time,
        'TRAVEL' AS seed_type
    FROM all_events e
    JOIN all_events a
      ON a.employee_id = e.employee_id
     AND a.event_time > e.event_time
     AND a.event_time < DATE_ADD(e.event_time, INTERVAL 4 HOUR)
     AND a.city <> e.city
    WHERE e.src = 'BADGE_EXIT'
    GROUP BY
        e.employee_id,
        e.event_time
),

all_seeds AS (
    SELECT * FROM badge_conflict_seed
    UNION ALL
    SELECT * FROM travel_conflict_seed
),

final_group AS (
    SELECT
        s.employee_id,
        s.seed_start_time,
        MAX(a.event_time) AS issue_end_time,
        GROUP_CONCAT(DISTINCT a.city ORDER BY a.city SEPARATOR ',') AS involved_cities,
        COUNT(DISTINCT a.city) AS city_count,
        MAX(CASE WHEN s.seed_type = 'TRAVEL' THEN 1 ELSE 0 END) AS has_travel_issue
    FROM all_seeds s
    JOIN all_events a
      ON a.employee_id = s.employee_id
     AND a.event_time BETWEEN s.seed_start_time
                         AND DATE_ADD(s.first_conflict_time, INTERVAL 30 MINUTE)
    GROUP BY
        s.employee_id,
        s.seed_start_time
)

SELECT
    employee_id,
    MIN(seed_start_time) AS issue_start_time,
    MAX(issue_end_time) AS issue_end_time,
    involved_cities,
    CASE
        WHEN city_count >= 3 THEN 'MULTI_CITY_CONFLICT'
        WHEN has_travel_issue = 1 THEN 'IMPOSSIBLE_TRAVEL'
        ELSE 'IMPOSSIBLE_LOCATION'
    END AS issue_type
FROM final_group
GROUP BY
    employee_id,
    involved_cities,
    city_count,
    has_travel_issue
ORDER BY employee_id;
