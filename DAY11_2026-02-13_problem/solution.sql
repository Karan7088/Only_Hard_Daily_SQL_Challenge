WITH RECURSIVE m AS (
    SELECT DATE('2025-01-01') d
    UNION ALL
    SELECT DATE_ADD(d, INTERVAL 1 MONTH)
    FROM m
    WHERE d < '2025-12-01'
),

pc AS (
    SELECT subscription_id, change_date, new_price
    FROM (
        SELECT
            subscription_id,
            DATE(change_date) change_date,
            new_price,
            ROW_NUMBER() OVER (
                PARTITION BY subscription_id, DATE(change_date)
                ORDER BY change_date DESC
            ) rn
        FROM plan_changes
    ) x
    WHERE rn = 1
),

pe AS (
    SELECT
        s.subscription_id,
        s.user_id,
        DATE(s.start_date) event_date,
        s.base_price price
    FROM subscriptions s

    UNION ALL

    SELECT
        s.subscription_id,
        s.user_id,
        p.change_date,
        p.new_price
    FROM pc p
    JOIN subscriptions s
      ON s.subscription_id = p.subscription_id
    WHERE p.change_date >= s.start_date
      AND (s.end_date IS NULL OR p.change_date <= s.end_date)
),

sm AS (
    SELECT
        s.subscription_id,
        s.user_id,
        m.d month,
        (
            SELECT price
            FROM pe
            WHERE subscription_id = s.subscription_id
              AND event_date <= m.d
            ORDER BY event_date DESC
            LIMIT 1
        ) price
    FROM subscriptions s
    JOIN m
      ON m.d >= DATE_FORMAT(s.start_date, '%Y-%m-01')
     AND (s.end_date IS NULL
          OR m.d <= DATE_FORMAT(s.end_date, '%Y-%m-01'))
),

um AS (
    SELECT
        user_id,
        month,
        COALESCE(SUM(price), 0) mrr
    FROM sm
    GROUP BY user_id, month
),

mb AS (
    SELECT
        user_id,
        month,
        mrr,
        LAG(mrr) OVER (PARTITION BY user_id ORDER BY month) prev_mrr,
        MAX(CASE WHEN mrr > 0 THEN 1 ELSE 0 END)
        OVER (PARTITION BY user_id
              ORDER BY month
              ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)
        had_prev
    FROM um
)

SELECT
    month,
    SUM(CASE WHEN prev_mrr > 0 AND mrr > prev_mrr
             THEN mrr - prev_mrr ELSE 0 END) expansion_mrr,
    SUM(CASE WHEN prev_mrr = 0 AND mrr > 0 AND had_prev = 1
             THEN mrr ELSE 0 END) reactivation_mrr,
    SUM(CASE WHEN prev_mrr > 0 AND mrr = 0
             THEN prev_mrr ELSE 0 END) churned_mrr,
    SUM(CASE WHEN prev_mrr IS NULL AND mrr > 0
             THEN mrr ELSE 0 END) new_mrr
FROM mb
GROUP BY month
ORDER BY month;