WITH RECURSIVE date_range AS (
    SELECT
        MIN(DATE(event_time)) AS balance_date,
        MAX(DATE(event_time)) AS max_balance_date
    FROM account_events

    UNION

    SELECT
        DATE_ADD(balance_date, INTERVAL 1 DAY) AS balance_date,
        max_balance_date
    FROM date_range
    WHERE DATE_ADD(balance_date, INTERVAL 1 DAY) <= max_balance_date
),

account_calendar AS (
    SELECT
        ae.account_id,
        dr.balance_date
    FROM date_range dr
    CROSS JOIN account_events ae
),

valid_events AS (
    SELECT
        *,
        CASE
            WHEN event_type IN ('withdrawal', 'fee', 'chargeback')
                THEN 0 - amount
            ELSE amount
        END AS signed_amount,

        ROW_NUMBER() OVER (
            PARTITION BY account_id, event_type, reference_id
            ORDER BY event_time
        ) AS duplicate_rank
    FROM account_events
    WHERE status = 'success'
      AND event_type != 'duplicate'
),

adjusted_events AS (
    SELECT
        *,
        CASE
            WHEN event_type = 'reversal'
                 AND amount = 0
            THEN 0 - IFNULL((
                SELECT signed_amount
                FROM valid_events ve
                WHERE ae.reference_id = ve.reference_id
                  AND ve.event_type != 'reversal'
                  AND ve.status = 'success'
                ORDER BY event_time ASC
                LIMIT 1
            ), 0)
            ELSE signed_amount
        END AS final_amount
    FROM valid_events ae
    WHERE duplicate_rank = 1
),

daily_net AS (
    SELECT
        account_id,
        DATE(event_time) AS balance_date,

        SUM(final_amount) OVER (
            PARTITION BY account_id, DATE(event_time)
        ) AS daily_net_amount,

        ROW_NUMBER() OVER (
            PARTITION BY account_id, DATE(event_time)
        ) AS daily_rank
    FROM adjusted_events
),

running_balance AS (
    SELECT
        MAX(balance_date) OVER (
            PARTITION BY account_id
        ) AS max_balance_date,

        account_id,
        balance_date,
        daily_net_amount,

        SUM(daily_net_amount) OVER (
            PARTITION BY account_id
            ORDER BY balance_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS closing_balance
    FROM daily_net
    WHERE daily_rank = 1
),

calendar_with_balance AS (
    SELECT
        ac.account_id,

        IFNULL(
            rb.max_balance_date,
            MAX(rb.balance_date) OVER (PARTITION BY ac.account_id)
        ) AS max_balance_date,

        ac.balance_date,
        IFNULL(rb.daily_net_amount, 0) AS daily_net_amount,
        rb.closing_balance
    FROM account_calendar ac
    LEFT JOIN running_balance rb
        ON rb.account_id = ac.account_id
       AND ac.balance_date = rb.balance_date
),

deduped_calendar AS (
    SELECT
        account_id,
        max_balance_date,
        balance_date,
        daily_net_amount,
        closing_balance
    FROM calendar_with_balance
    GROUP BY
        account_id,
        max_balance_date,
        balance_date,
        daily_net_amount,
        closing_balance
    ORDER BY
        account_id,
        balance_date
),

final_output AS (
    SELECT
        account_id,
        balance_date,
        daily_net_amount,

        IFNULL(
            closing_balance,
            LAG(closing_balance) OVER (
                PARTITION BY account_id
                ORDER BY balance_date
            )
        ) AS closing_balance
    FROM deduped_calendar
    WHERE max_balance_date >= balance_date
    ORDER BY
        account_id,
        balance_date
)

SELECT *
FROM final_output
WHERE closing_balance IS NOT NULL;
