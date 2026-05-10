 WITH RECURSIVE snapshot_intervals AS (

    SELECT
        MIN(event_time) AS tme,
        MAX(event_time) AS mx
    FROM hashtag_events

    UNION

    SELECT
        tme + INTERVAL 10 MINUTE,
        mx
    FROM snapshot_intervals
    WHERE tme <= mx
),

hashtag_snapshot_counts AS (

    SELECT
        snapshot_intervals.tme,
        h.*,

        ROW_NUMBER() OVER(
            PARTITION BY tme, hashtag
        ) AS rn,

        COUNT(*) OVER(
            PARTITION BY tme, hashtag
        ) AS cnt

    FROM snapshot_intervals
    LEFT JOIN hashtag_events h
        ON h.event_time <= snapshot_intervals.tme

    ORDER BY 1, 5
),

top_hashtag_ranking AS (

    SELECT
        tme AS snapshot_time,
        hashtag,
        cnt AS usage_count,

        ROW_NUMBER() OVER(
            PARTITION BY tme
            ORDER BY cnt DESC
        ) AS trend_rank

    FROM hashtag_snapshot_counts

    WHERE rn = 1
)

SELECT *
FROM top_hashtag_ranking
WHERE trend_rank <= 3;
