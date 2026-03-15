 WITH cte AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY user_id, show_id, episode_id
        ) AS rnn,

        IFNULL(
            TIMESTAMPDIFF(
                MINUTE,
                LAG(watch_time) OVER (
                    PARTITION BY user_id, show_id 
                    ORDER BY watch_time
                ),
                watch_time
            ),
            0
        ) AS tmdf
    FROM watch_history
),

cte2 AS (
    SELECT 
        *,
        SUM(tmdf) OVER (
            PARTITION BY user_id, show_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS sm,

        ROW_NUMBER() OVER (
            PARTITION BY user_id, show_id
        ) AS rn

    FROM cte a

    WHERE rnn = (
        SELECT MAX(rnn)
        FROM cte
        WHERE show_id = a.show_id
          AND user_id = a.user_id
          AND episode_id = a.episode_id
    )
),

cte3 AS (
    SELECT 
        *,
        COUNT(*) OVER (
            PARTITION BY user_id, show_id
        ) AS c,

        IFNULL(
            rn - LAG(rn) OVER (
                PARTITION BY user_id, show_id
            ),
            1
        ) AS df

    FROM cte2
    WHERE tmdf <= 60
)

SELECT 
    user_id,
    show_id
FROM cte3
WHERE c >= 3
GROUP BY 1, 2;
