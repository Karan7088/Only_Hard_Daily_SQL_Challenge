 WITH base AS (
    SELECT
        MIN(session_id) AS session_id,
        user_id,
        w.video_id,
        SUM(watch_time) AS watch_time,
        video_length,
        MAX(watch_date) AS watch_date,
        MAX(likes) AS likes,
        MAX(comments) AS comments,
        MAX(shares) AS shares
    FROM watch_sessions w
    LEFT JOIN video_engagement v
        ON w.video_id = v.video_id
    GROUP BY
        user_id,
        w.video_id,
        video_length
),

cte2 AS (
    SELECT
        *,
        
        ROUND(
            AVG(watch_time / video_length)
            OVER (PARTITION BY user_id, video_id), 
        2) AS avg_watch_ratio,

        ROUND(
            AVG(watch_time / video_length)
            OVER (PARTITION BY user_id, video_id), 
        2)
        + (likes * 0.2)
        + (comments * 0.2)
        + (shares * 0.1) AS engagement_score,

        CASE
            WHEN (likes + comments + shares) > 500 THEN
                ROUND(
                    EXP(-DATEDIFF(CURDATE(), watch_date) / 30) *
                    (
                        ROUND(
                            AVG(watch_time / video_length)
                            OVER (PARTITION BY user_id, video_id), 
                        2)
                        + (likes * 0.2)
                        + (comments * 0.2)
                        + (shares * 0.1)
                    ) * 1.2,
                2)

            ELSE
                ROUND(
                    EXP(-DATEDIFF(CURDATE(), watch_date) / 30) *
                    (
                        ROUND(
                            AVG(watch_time / video_length)
                            OVER (PARTITION BY user_id, video_id), 
                        2)
                        + (likes * 0.2)
                        + (comments * 0.2)
                        + (shares * 0.1)
                    ),
                2)
        END AS final_score

    FROM base
)


SELECT
    user_id,
    video_id,
    ROW_NUMBER() OVER (
        PARTITION BY user_id
        ORDER BY
            final_score DESC,
            watch_date DESC,
            video_id
    ) AS ranking
FROM cte2;
