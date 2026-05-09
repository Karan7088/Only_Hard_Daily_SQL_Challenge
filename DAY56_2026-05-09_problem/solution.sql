 WITH RECURSIVE snapshot_intervals AS (

    SELECT
        MIN(event_time) AS snapshot_time,
        MAX(event_time) AS max_time
    FROM score_events

    UNION

    SELECT
        snapshot_time + INTERVAL 5 MINUTE,
        max_time
    FROM snapshot_intervals
    WHERE snapshot_time + INTERVAL 5 MINUTE <= max_time
),

expanded_snapshots AS (

    SELECT
        player_id,
        event_time,
        snapshot_intervals.snapshot_time,
        score_change

    FROM snapshot_intervals
    INNER JOIN score_events s
        ON s.event_time <= snapshot_intervals.snapshot_time

    ORDER BY 3, 2, 1
),

player_running_scores AS (

    SELECT *,
    
           (
               SELECT SUM(score_change)
               FROM score_events
               WHERE a.player_id = player_id
                 AND event_time <= snapshot_time
           ) AS total_score,

           ROW_NUMBER() OVER(
               PARTITION BY player_id, snapshot_time
           ) AS dedup

    FROM expanded_snapshots a
),

leaderboard_ranking AS (

    SELECT *,
    
           DENSE_RANK() OVER(
               PARTITION BY snapshot_time
               ORDER BY total_score DESC
           ) AS current_rank

    FROM player_running_scores

    WHERE dedup = 1
)

SELECT
    snapshot_time,
    
    player_id,
    
    total_score AS total_score_till_now,
    
    current_rank AS rank_at_that_time,

    IFNULL(
        LAG(current_rank) OVER(
            PARTITION BY player_id
            ORDER BY snapshot_time
        ),
        1
    ) - current_rank AS rank_change_from_previous_snapshot

FROM leaderboard_ranking

ORDER BY 1, 4;
