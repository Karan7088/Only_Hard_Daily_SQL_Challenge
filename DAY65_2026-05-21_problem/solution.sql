WITH base AS (
    SELECT s.*,
           su.usage_id,
           su.usage_date,
           su.minutes_used,

           DATEDIFF(
               renewal_date,
               usage_date
           ) AS df,

           CASE
               WHEN DATEDIFF(
                        renewal_date,
                        usage_date
                    ) <= 7
               THEN 1
               ELSE 2
           END AS st

    FROM subscriptions s
    LEFT JOIN subscription_usage su
           ON s.customer_id = su.customer_id

    WHERE status = 'active'
)

SELECT customer_id,
       subscription_id,
       plan_name,
       renewal_date,

       SUM(
           CASE
               WHEN st = 2
               THEN minutes_used
           END
       ) AS previous_7_day_usage,

       SUM(
           CASE
               WHEN st = 1
               THEN minutes_used
           END
       ) AS latest_7_day_usage,

       ROUND(
           (
               SUM(
                   CASE
                       WHEN st = 2
                       THEN minutes_used
                   END
               )
               -
               SUM(
                   CASE
                       WHEN st = 1
                       THEN minutes_used
                   END
               )
           )
           /
           SUM(
               CASE
                   WHEN st = 2
                   THEN minutes_used
               END
           ) * 100.0,
           2
       ) AS usage_drop_pct,

       CASE
           WHEN ROUND(
                    (
                        SUM(
                            CASE
                                WHEN st = 2
                                THEN minutes_used
                            END
                        )
                        -
                        SUM(
                            CASE
                                WHEN st = 1
                                THEN minutes_used
                            END
                        )
                    )
                    /
                    SUM(
                        CASE
                            WHEN st = 2
                            THEN minutes_used
                        END
                    ) * 100.0,
                    2
                ) BETWEEN 20 AND 49.99
           THEN 'MEDIUM_RISK'

           WHEN ROUND(
                    (
                        SUM(
                            CASE
                                WHEN st = 2
                                THEN minutes_used
                            END
                        )
                        -
                        SUM(
                            CASE
                                WHEN st = 1
                                THEN minutes_used
                            END
                        )
                    )
                    /
                    SUM(
                        CASE
                            WHEN st = 2
                            THEN minutes_used
                        END
                    ) * 100.0,
                    2
                ) BETWEEN 50 AND 99
           THEN 'HIGH_RISK'

           WHEN ROUND(
                    (
                        SUM(
                            CASE
                                WHEN st = 2
                                THEN minutes_used
                            END
                        )
                        -
                        SUM(
                            CASE
                                WHEN st = 1
                                THEN minutes_used
                            END
                        )
                    )
                    /
                    SUM(
                        CASE
                            WHEN st = 2
                            THEN minutes_used
                        END
                    ) * 100.0,
                    2
                ) < 20
           THEN 'low_risk'

           ELSE 'EXTREME_RISK'
       END AS risk_level

FROM base

WHERE df <= 14

GROUP BY 1,2,3,4; 
