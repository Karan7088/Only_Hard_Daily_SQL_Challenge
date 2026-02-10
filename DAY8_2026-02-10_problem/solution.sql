WITH base_data AS (
    SELECT
        s.sensor_id,
        s.location,
        sr.reading_id,
        sr.reading_time,
        sr.temperature
    FROM sensor_readings sr
    LEFT JOIN sensors s
        ON sr.sensor_id = s.sensor_id
),

sensor_stats AS (
    SELECT
        sensor_id,
        location,
        COUNT(*) AS total_readings,
        COUNT(CASE WHEN temperature IS NOT NULL THEN 1 END) AS valid_readings,
        AVG(CASE WHEN temperature IS NOT NULL THEN temperature END) AS avg_temperature,
        MIN(CASE WHEN temperature IS NOT NULL THEN temperature END) AS min_temperature,
        MAX(CASE WHEN temperature IS NOT NULL THEN temperature END) AS max_temperature
    FROM base_data
    GROUP BY 1,2
),

time_diff AS (
    SELECT
        sensor_id,
        temperature,
        temperature - LAG(temperature)
            OVER (PARTITION BY sensor_id ORDER BY reading_time) AS temp_jump,
        TIMESTAMPDIFF(
            HOUR,
            LAG(reading_time) OVER (PARTITION BY sensor_id ORDER BY reading_time),
            reading_time
        ) AS hour_jump
    FROM base_data
),

sensor_gaps AS (
    SELECT
        sensor_id,
        IFNULL(MAX(temp_jump),0) AS max_temperature_jump,
        IFNULL(MAX(hour_jump),0) AS longest_inactivity_hours
    FROM time_diff
    GROUP BY 1
),

hot_runs AS (
    SELECT
        sensor_id,
        reading_id,
        IFNULL(
            reading_id - LAG(reading_id)
                OVER (PARTITION BY sensor_id ORDER BY reading_id),
            1
        ) AS diff_flag
    FROM base_data
    WHERE temperature >= 80.00
),

run_breaks AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY sensor_id) AS rn
    FROM hot_runs
    WHERE diff_flag > 1
),

run_groups AS (
    SELECT
        h.*,
        IFNULL(
            b.rn,
            MIN(b.rn) OVER (
                PARTITION BY h.sensor_id
                ORDER BY h.reading_id
                ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
            ) - 1
        ) AS rn
    FROM hot_runs h
    LEFT JOIN run_breaks b
        ON h.sensor_id = b.sensor_id
       AND h.reading_id = b.reading_id
),

run_lengths AS (
    SELECT
        sensor_id,
        rn,
        COUNT(*) AS cnt
    FROM run_groups
    GROUP BY 1,2
),

overheat_max AS (
    SELECT
        sensor_id,
        MAX(cnt) AS max_overheated_duration_hours
    FROM run_lengths
    GROUP BY 1
),

overheat_all AS (
    SELECT * FROM overheat_max
    UNION
    SELECT sensor_id, 0
    FROM base_data
    WHERE sensor_id NOT IN (SELECT sensor_id FROM overheat_max)
)

SELECT
    a.*,
    b.max_temperature_jump,
    b.longest_inactivity_hours,
    c.max_overheated_duration_hours,
    CASE
        WHEN b.longest_inactivity_hours > 24 THEN 1 ELSE 0
    END AS inactive_flag,
    CASE
        WHEN a.max_temperature > 100 OR a.min_temperature < 0 THEN 1 ELSE 0
    END AS anomaly_temp_flag
FROM sensor_stats a
LEFT JOIN sensor_gaps b
    ON a.sensor_id = b.sensor_id
INNER JOIN overheat_all c
    ON a.sensor_id = c.sensor_id;
