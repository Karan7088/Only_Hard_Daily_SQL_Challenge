 WITH elevator_sequence AS (

    SELECT
        log_id,
        elevator_id,
        log_time,
        floor_no,
        passenger_count,

        ROW_NUMBER() OVER(
            PARTITION BY elevator_id
            ORDER BY log_time
        ) AS rn

    FROM elevator_logs
),

empty_state_rows AS (

    SELECT
        log_id,
        elevator_id,
        log_time,
        floor_no,
        passenger_count,
        rn,

        rn - ROW_NUMBER() OVER(
            PARTITION BY elevator_id
            ORDER BY log_time
        ) AS empty_group

    FROM elevator_sequence

    WHERE passenger_count = 0
),

empty_movement_blocks AS (

    SELECT
        log_id,
        elevator_id,
        log_time,
        rn,
        empty_group,

        MAX(floor_no) OVER(
            PARTITION BY elevator_id, empty_group
        ) - MIN(floor_no) OVER(
            PARTITION BY elevator_id, empty_group
        ) AS empty_floors_travelled,

        MIN(log_time) OVER(
            PARTITION BY elevator_id, empty_group
        ) AS empty_block_start_time

    FROM empty_state_rows
),

elevator_state_mapping AS (

    SELECT
        elevator_sequence.log_id,
        elevator_sequence.elevator_id,
        elevator_sequence.log_time,
        elevator_sequence.passenger_count,
        elevator_sequence.rn,

        IFNULL(
            empty_movement_blocks.empty_block_start_time,
            MAX(elevator_sequence.log_time) OVER(
                PARTITION BY elevator_sequence.elevator_id
            )
        ) AS mapped_empty_time,

        empty_movement_blocks.empty_floors_travelled,
        empty_movement_blocks.empty_group

    FROM elevator_sequence

    LEFT JOIN empty_movement_blocks
        ON empty_movement_blocks.rn = elevator_sequence.rn
       AND elevator_sequence.log_id = empty_movement_blocks.log_id
),

trip_boundary_mapping AS (

    SELECT
        log_id,
        elevator_id,
        log_time,
        passenger_count,
        mapped_empty_time,
        empty_floors_travelled,
        empty_group,

        MIN(mapped_empty_time) OVER(
            PARTITION BY elevator_id
            ORDER BY log_time
            ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
        ) AS trip_end_time

    FROM elevator_state_mapping
),

trip_metrics AS (

    SELECT
        elevator_id,
        log_time,
        passenger_count,
        trip_end_time,

        (
            SELECT empty_floors_travelled
            FROM trip_boundary_mapping
            WHERE A.elevator_id = elevator_id
              AND trip_boundary_mapping.log_time = A.trip_end_time
        ) AS trip_empty_floors,

        (
            SELECT MAX(passenger_count)
            FROM trip_boundary_mapping
            WHERE A.elevator_id = elevator_id
              AND log_time BETWEEN A.log_time AND A.trip_end_time
        ) AS max_passengers

    FROM trip_boundary_mapping A
),

trip_candidates AS (

    SELECT
        elevator_id,
        log_time,
        trip_end_time,
        trip_empty_floors,
        max_passengers,

        ROW_NUMBER() OVER(
            PARTITION BY elevator_id, trip_end_time
            ORDER BY max_passengers DESC
        ) AS trip_pick_rank,

        MAX(trip_end_time) OVER(
            PARTITION BY elevator_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ) AS previous_trip_end_time

    FROM trip_metrics
)

SELECT
    elevator_id,

    ROW_NUMBER() OVER(
        PARTITION BY elevator_id
    ) AS trip_id,

    log_time AS trip_start_time,

    trip_end_time,

    max_passengers,

    (
        SELECT MAX(trip_empty_floors)
        FROM trip_candidates
        WHERE a.elevator_id = elevator_id
          AND a.previous_trip_end_time = log_time
    ) AS pre_trip_empty_floors,

    CASE
        WHEN max_passengers > 5
        THEN 'CAPACITY_VIOLATION'

        WHEN (
            SELECT MAX(trip_empty_floors)
            FROM trip_candidates
            WHERE a.elevator_id = elevator_id
              AND a.previous_trip_end_time = log_time
        ) > 0
        THEN 'EMPTY_MOVEMENT'

        ELSE 'Normal'
    END AS trip_status

FROM trip_candidates a

WHERE trip_pick_rank = 1
  AND trip_end_time != log_time;
